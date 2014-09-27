declare -A ROUTES

router::getparams(){

    read req
    # Parse params
    local http_req=($req)
    local http_route=${http_req[1]}

    # TODO parse and return parameters
    if [[ $req =~ "?" ]]; then
        echo $req | sed "s/?/\n/" | tail -1
    else
        echo "Nothing."
    fi

}

router::parse() {
    local resource=$1;shift
    local tokens=$( echo $resource | sed 's/\//\/ /g')
    local parsed=""

    for token in $tokens; do
        if [[ ! $token =~ ^: ]]; then
            parsed+=$token
        else
            parsed+=.*/
        fi
    done

    echo $parsed

}

router::match() {
    local request=$1; shift
    local route=$1; shift
    
    # If matching a root
    if [[ $request == '/' || $route == '/' ]]; then
        if [[ $route == $request ]]; then
            return 0 
        else
            return 1
        fi
    fi

    local parsed_request=$(echo $request | sed "s/\// /g" | sed "s/^ *//")
    local parsed_route=$(echo $route | sed "s/\// /g" | sed "s/^ *//")



    for token in $parsed_route; do
        local hd=$(echo $parsed_request | sed "s/ .*//" )
        local tl=$(echo $parsed_request | sed "s/^\w* //" )
        
        # Match a route
        if [[ $token == $hd ]]; then
            parsed_request=$tl
            continue
        fi

        # Match a param
        if [[ $token == :* ]]; then
            parsed_request=$tl
            continue
        fi
        #echo "Does not match"
        return 1
    done
    #echo "Does match"
    return 0
        
}

router::when() {

    local method=$1; shift
    local resource=$1; shift
    local ctrl=$1; shift
    
    ROUTES["$method$resource"]=$ctrl
    #echo $method $resource

}


router::follow() {
    
    local method=$1; shift
    local resource=$1; shift
    local params=$1; shift
    
    # Route
    for route in ${!ROUTES[@]}; do
        if [[ $route =~ ^$method ]]; then
            #echo "Matching method for $route"
            route_resource=$(echo $route | sed 's/^.*\//\//')
            router::match $resource $route_resource
            if [[ $? == 0 ]]; then
                #echo "Matching route for $route"
                echo -e "$( ${ROUTES[$route]} $params )"
                break
            else
                #echo "It does not match" 
                continue
            fi
        else
            #echo "Not matching method"
            continue
        fi
    done
    #echo "No routes found"
    return 1

}

