declare -A ROUTES

router::define() {

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
        echo -e "$( ${ROUTES[$action]} $params )"
    else
        echo 'No route.'
    fi

}

