#!/bin/bash

# Require library functions
source lib/server.sh

# Require application
source lib/controllers.sh

# Configure some routes
router::when GET / ctrl::root
router::when GET /readfile ctrl::readfile
router::when GET /writefile ctrl::writefile
router::when GET /showmounts ctrl::showmounts
router::when GET /showview ctrl::showview

# Start the app
http::server
