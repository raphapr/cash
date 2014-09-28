#!/bin/bash

source ../lib/router.sh

echo "-- router::match"
# Match routes
router::match "/dynamic/foo/again/bar/" "/dynamic/:uid/again/:pid"
if [[ $? == 0 ]]
then
    echo "Should match dynamic routes"
fi

# Match routes
router::match "/dynamic/foo/aga/bar/" "/dynamic/:uid/again/:pid"
if [[ $? == 1 ]]
then
    echo "Should not match a wrong route"
fi

# Match routes
router::match "/test/" "/"
if [[ $? == 1 ]]
then
    echo "Should not match always the root"
fi


echo "-- router::follow"
# Follow routes
unit::root(){
    echo "Should follow the root only once"
}
router::when GET / unit::root
router::follow "GET" "/"

# Follow routes
unit::one(){
    echo "Should follow this route"
}
router::when GET /one unit::one
router::follow "GET" "/one"

# Follow routes
unit::two(){
    echo "Should follow this route also"
}
router::when GET /one/two unit::two
router::follow "GET" "/one/two"

# Follow routes
router::follow "POST" "/one/two"
if [[ $? == 1 ]]
then
    echo "Should not match a wrong method"
fi
