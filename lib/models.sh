# Models

# Create this session model
MODEL="/tmp/model.$$.$RANDOM.tmp"
touch $MODEL

model::create() {
    read input
    touch $MODEL
}

model::retrieve() {
    if [[ -f "$MODEL" ]]; then
        cat $MODEL
    else
        echo "No data."
    fi
}

model::update() {
    read data
    echo "$data" > $MODEL
}

model::delete() {
    echo 'nothing'
}

