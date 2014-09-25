# Controllers

ctrl::root() {
    local params=$1
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
    echo -e $view_content | view::render
}
