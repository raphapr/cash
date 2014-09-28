# Controllers

ctrl::root() {
    local params=$1; shift
    echo "Coolio $params"
}

ctrl::readfile() {
    echo -e "$(model::retrieve)"
}

ctrl::createfile() {
    echo -e "$(model::create)"
    echo "Created new file."
}

ctrl::writefile() {
    echo "Yes man. No way." | model::update
    echo "Done."
}

ctrl::showmounts() {
    echo -e "$(cat /proc/mounts)"
}

ctrl::showview() {
   local view_content=$(cat views/sample.html)
    
   # Declare some parameters in the controllers
   # as view_data and retrieve them in view::render
   declare -A view_data
   
   view_data["koala"]="cat"
   view_data["panda"]="rabbit"
   view_data["lorem_ipsum"]=$(cat views/lorem_ipsum.html)

   echo -e $view_content | view::render 
}

ctrl::dynamic() {
    local params=$1; shift
    echo "Dynamic route with params $1"

}
