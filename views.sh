# This will be the view engine

TEMPLATE="tmp/template.$$.tmp"
mkfifo $TEMPLATE

view::render(){
    read view_content
    echo $view_content | view::parse
}

view::parse(){
   declare -A view_tokens
   
   view_tokens["test_token"]="foobar"

   read view_parse_in 
   
   for it in "${!view_tokens[@]}"; do
       local view_parse_out=$(echo $view_parse_in | sed "s/{{$it}}/${view_tokens[$it]}/g")
   done
       
   echo -e $view_parse_out
   
}
