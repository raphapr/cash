declare -A ROUTES

router::when() {

    local method=$1; shift
    local action=$1; shift
    local ctrl=$1; shift
    
    ROUTES[$action]=$ctrl

}


router::follow() {
    
    local method=$1; shift
    local action=$1; shift
    local params=$1; shift
    
    # Route
    if [[ ${ROUTES[$action]} ]]
    then
        http::code 200 "Ok"
        http::headers
        echo -e "$( ${ROUTES[$action]} $params )"
    else
        http::code "404" "Not Found"
        http::headers
        echo 'No route.'
    fi

}

