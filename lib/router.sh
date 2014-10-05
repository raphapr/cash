declare -A ROUTES

router::headers(){
    
    read response_body
    
    declare -A http_headers

    http_headers['Content-Type']="text/html"
    http_headers['Content-Length']=${#response_body}

    for header in "${!http_headers[@]}"; do
        echo -e $header: ${http_headers[$header]}
    done
    
    echo -e "\n"
    echo -e $response_body
}

router::code() {

    local code=$1; shift
    local reason=$1; shift
    
    echo -e  "HTTP/1.1 $code $reason"

}

# TODO 
# this support only get params for now
router::getparams(){

    read req
    # Parse params
    local http_req=($req)
    local http_route=${http_req[1]}

    if [[ $req =~ "?" ]]; then
        echo $req | sed "s/?/\n/" | tail -1
    else
        echo "Nothing."
    fi

}

router::match() {
    local request=$1; shift
    local route=$1; shift

    # If parsed route is empty
    if [[ $request == '/' || $route == '/' ]]; then
        if [[ $route == $request ]]; then
            return 0 
        else
            return 1
        fi
    fi

    local parsed_request=$(echo $request | sed "s/\// /g" | sed "s/^ *//")
    local parsed_route=$(echo $route | sed "s/\// /g" | sed "s/^ *//")

    # Number of tokens must be the same
    if [[ $(echo $parsed_request | wc -w) != $(echo $parsed_route | wc -w) ]]; then
        #echo "$parsed_request - $parsed_route"
        return 1
    fi

    for token in $parsed_route; do
        local hd=$(echo $parsed_request | sed "s/ .*//" )
        local tl=$(echo $parsed_request | sed "s/^\w* //" )
        
        # Match a param
        if [[ $token == :* ]]; then
            parsed_request=$tl
            continue
        fi
        
        # Match a route
        if [[ $token == $hd ]]; then
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
            route_resource=$(echo $route | sed 's/^\w*\//\//')
            #echo "$resource $route_resource"
            router::match $resource $route_resource
            if [[ $? == 0 ]]; then
                #echo "Matching route for $route"
                router::code "200" "Ok"
                echo -e "$( ${ROUTES[$route]} $params )" | router::headers
                return 0
            else
                #echo "It does not match" 
                continue
            fi
        else
            #echo "Not matching method"
            continue
        fi
    done
    router::code "404" "Not found."
    echo -e "Not Found." | router::headers
    return 1

}

