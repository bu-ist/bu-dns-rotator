#!/bin/bash

# 

yml="docker-compose.case1.yml"

function up() {
    docker-compose -f $yml up -d --build
}

function down() {
    docker-compose -f $yml down
}

up

output1=`docker-compose -f $yml run --rm box nslookup backend1 10.6.0.10`
if [[ $output1 != *"Address: 10.6.0.11"* ]]; then
    echo "Wrong output for unmodified backend1: $output1"
    down
    exit 1
fi

docker-compose -f $yml exec dns change-ip.sh backend1 backend2
docker-compose -f $yml restart dns

output1=`docker-compose -f $yml run --rm box nslookup backend1 10.6.0.10`
if [[ $output1 != *"Address: 10.6.0.12"* ]]; then
    echo "Wrong output for modified backend1: $output1"
    down
    exit 1
fi

down