#!/bin/bash

CONTAINER_NAME=$1

if [[ -z $CONTAINER_NAME ]]; then
  echo 'Invalid arguments!'
  echo 'Example: ./RunContainer.sh [container_name]'
  exit 1
fi

# Проверим, не запущен ли уже контейнер
is_running=$(sudo docker ps --filter name=$CONTAINER_NAME --format '{{.ID}}')
if [ -n "${IS_RUNNING}" ]; then

    echo Container "$CONTAINER_NAME" is running. It will be stopped...
    sudo docker container stop $CONTAINER_NAME

fi

# Запускаем
sudo docker run \
--detach \
--restart=always \
--volume /opt/yt_dwn_bot/Logs:/opt/Logs \
--volume /opt/yt_dwn_bot/config.ini:/opt/config.ini \
--volume /etc/timezone:/etc/timezone \
--name $CONTAINER_NAME \
$CONTAINER_NAME

# И посмотрим, что там получилось
sudo docker ps --filter="name=$CONTAINER_NAME"
