#!/bin/bash

export UI_IMAGE_NAME=paulwizviz/react-dashboard-ui
export SERVER_IMAGE_NAME=paulwizviz/react-dashboard-server
export IMAGE_TAG=dev
export NODE_IMAGE_TAG=13.10.1

COMMAND="$1"

function dep() {
    docker run -v ${PWD}/ui:/opt -w /opt -t --rm node:${NODE_IMAGE_TAG} ./dep.sh
}

function build() {
    docker build -f ./build/server.dockerfile -t ${SERVER_IMAGE_NAME}:${IMAGE_TAG} .
    docker build -f ./build/ui.dockerfile -t ${UI_IMAGE_NAME}:${IMAGE_TAG} .
}

function run() {
    docker-compose -f ./deployments/docker-compose.yaml up -d
}

function stop(){
    docker-compose -f ./deployments/docker-compose.yaml down
}

function clean(){
    docker-compose -f ./deployments/docker-compose.yaml down
    docker rmi -f ${UI_IMAGE_NAME}:${IMAGE_TAG}
    docker rmi -f ${SERVER_IMAGE_NAME}:${IMAGE_TAG}
    docker rmi -f $(docker images --filter "dangling=true" -q)
}

case $COMMAND in
    "build")
        build
        ;;
    "clean")
        clean
        ;;
    "dep")
        dep
        ;;
    "run")
        run
        ;;
    "stop")
        stop
        ;;
    *)
        echo "$0 [build | run | stop | clean ]"
        ;;
esac