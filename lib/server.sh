#!/bin/bash

# Configuration
[[ $PORT ]] || PORT=8000
[[ $SOCKET ]] || SOCKET="/tmp/socket.$$.tmp"

# Require framework
source lib/router.sh
source lib/models.sh
source lib/views.sh

server::handler() {

    read req

    local http_req=($req)
    local http_verb=${http_req[0]}
    local http_path=${http_req[1]} 
    local http_route=$(echo $http_path | sed "s/?/\n/" | head -1)
    local http_params=$(echo $req | router::getparams)
    
    # DEBUG throw request
    #echo $req

    router::follow $http_verb $http_route $http_params 

}

server::listen() {
    
    # Run
    mkfifo $SOCKET

    echo -e "Starting server on port $PORT\n";
    echo ">> Listening..."

    # Enter loop
    while true; do 
        cat $SOCKET  | nc -l -p $PORT -c 0 | server::handler > $SOCKET
    done

}
