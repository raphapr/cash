#!/bin/bash

source router.sh
source models.sh
source controllers.sh

PORT=8000

echo -e "Starting server on port $PORT\n";

# Create named pipe
SOCKET="tmp/pipe.$$.tmp"
mkfifo $SOCKET

http::getparams(){
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

http::handler() {
    read req

    local http_req=($req)
    local http_verb=${http_req[0]}
    local http_path=${http_req[1]} 
    local http_route=$(echo $http_path | sed "s/?/\n/" | head -1)
    local http_params=$(echo $req | http::getparams)

    # DEBUG throw request
    echo $req

    router::follow $http_verb $http_route $http_params

}

# Routes
router::define GET / ctrl::root
router::define GET /readfile ctrl::readfile
router::define GET /writefile ctrl::writefile
router::define GET /showmounts ctrl::showmounts

# Ok
echo "Listening..."

# Enter loop
while true; do 
    cat $SOCKET  | nc -l -p $PORT -q 1 | http::handler > $SOCKET
done
