# This will be the view engine

view::render(){
   read view_content
    
   for it in "${!view_data[@]}"; do
       view_content=$(echo $view_content | sed "s/{{$it}}/${view_data[$it]}/g")
   done
       
   echo -e $view_content
   
   [[ $view_data ]] && unset view_data
   
}
