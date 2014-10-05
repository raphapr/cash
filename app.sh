#!/bin/bash

# Require library functions
source lib/server.sh

# Require application
source app/controllers.sh

# Configure some routes
router::when GET / ctrl::root
router::when GET /readfile ctrl::readfile
router::when GET /writefile ctrl::writefile
router::when GET /showmounts ctrl::showmounts
router::when GET /showview ctrl::showview
router::when GET /dynamic/:id ctrl::dynamic
router::when GET /dynamic/:id/again/:property ctrl::dynamic

# Start the app
server::listen
