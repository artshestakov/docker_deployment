#!/bin/bash

CONTAINER_NAME=$1
DOCKER_FILE_PATH=$2
PARENT_DIR="$(dirname "$DOCKER_FILE_PATH")"

if [[ -z $CONTAINER_NAME || -z $DOCKER_FILE_PATH ]]; then
  echo 'Invalid arguments!'
  echo 'Example: ./BuildContainer.sh [container_name] [path_to_dockerfile]'
  exit 1
fi

# Переходим в директорию скрипта
cd "$(dirname "$0")"

# Если контейнер существует - останавливаем и удаляем
if [ "$(sudo docker ps --all --quiet --filter="name=$CONTAINER_NAME")" ]; then

    echo Container "$CONTAINER_NAME" is exists. It will be deleted...
    sleep 1

    echo Stopping container...
    sudo docker container stop $(sudo docker ps --all --quiet --filter="name=$CONTAINER_NAME")

    echo Deleting container...
    sudo docker container rm --force $(sudo docker ps --all --quiet --filter="name=$CONTAINER_NAME")

fi

# Если образ существует - удаляем
if [ "$(sudo docker images --quiet $CONTAINER_NAME)" ]; then

    echo Deleting image...
    sudo docker image rm --force $(sudo docker images --quiet $CONTAINER_NAME)

fi

# Собираем
sudo docker build \
  --no-cache \
  --progress=plain \
  --tag $CONTAINER_NAME \
  --file $DOCKER_FILE_PATH \
  $PARENT_DIR

