#!/bin/bash

export UI_IMAGE_DEV=openconsentia/reatcjs-ui-dev
export UI_IMAGE_PROD=openconsentia/reactjs-ui-prod
export SERVER_IMAGE=openconsentia/reactjs-server
export IMAGE_TAG=current

COMMAND="$1"
SUBCOMMAND="$2"

message="Usage: $0 build [dev | prod] | clean | run [dev | prod] | status | stop [dev | prod]"

if [ -z "$COMMAND" ]; then
    echo $message
    exit 1
fi

function build() {
    local cmd="$1"

    case $cmd in
    "dev")
        docker build -f ./build/ui.dev.dockerfile -t ${UI_IMAGE_DEV}:${IMAGE_TAG} .
        ;;
    "prod")
        docker build -f ./build/ui.prod.dockerfile -t ${UI_IMAGE_PROD}:${IMAGE_TAG} .
        ;;
    *)
        echo "Usage: $0 build [dev | prod]"
        exit 1
        ;;
    esac

    docker build -f ./build/server.dockerfile -t ${SERVER_IMAGE}:${IMAGE_TAG} .
}

function run() {
    local cmd="$1"

    case $cmd in
    "dev")
        docker-compose -f ./deployments/docker-compose-dev.yaml up -d
        ;;
    "prod")
        docker-compose -f ./deployments/docker-compose-prod.yaml up -d
        ;;
    *)
        echo "Usage: $0 run [dev | prod]"
        exit 1
        ;;
    esac
}

function stop(){
    local cmd="$1"

    case $cmd in
    "dev")
        docker-compose -f ./deployments/docker-compose-dev.yaml down
        ;;
    "prod")
        docker-compose -f ./deployments/docker-compose-prod.yaml down
        ;;
    *)
        echo "Usage: $0 stop [dev | prod]"
        exit 1
        ;;
    esac
}

function status(){
    docker ps -a
}

function clean(){ 

    docker-compose -f ./deployments/docker-compose-dev.yaml down
    docker-compose -f ./deployments/docker-compose-prod.yaml down

    docker rmi -f ${SERVER_IMAGE}:${IMAGE_TAG}
    docker rmi -f ${UI_IMAGE_DEV}:${IMAGE_TAG}
    docker rmi -f ${UI_IMAGE_PROD}:${IMAGE_TAG}
    docker rmi -f $(docker images --filter "dangling=true" -q)
}

case $COMMAND in
    "build")
        build $SUBCOMMAND
        ;;
    "clean") 
        clean
        ;;
    "run")
        run $SUBCOMMAND
        ;;
    "status")
        status
        ;;
    "stop")
        stop $SUBCOMMAND
        ;;
    *)
        echo $message
        ;;
esac