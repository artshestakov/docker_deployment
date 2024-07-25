#!/bin/bash

CONTAINER_NAME=$1

if [[ -z $CONTAINER_NAME ]]; then
    echo "Argument is empty!"
    echo "Example: ./BuildContainer.sh [container_name]"
    exit 1
fi

# Проверим, есть ли вообще такой контейнер
sudo docker-compose ps $CONTAINER_NAME &> /dev/null
if [ "$(echo $?)" -ne "0" ]; then
    echo "Such container does not exist! Check your docker-compose.yml"
    exit 1
fi

# Нашли контейнер - попробуем выполнить его остановку и удаление
sudo docker-compose rm --force --stop $CONTAINER_NAME
if [ "$(echo $?)" -ne "0" ]; then
    exit 1
fi

# Выполняем сборку контейнера
sudo docker-compose build --parallel --progress plain $CONTAINER_NAME
if [ "$(echo $?)" -ne "0" ]; then
    exit 1
fi

# И запускаем
sudo docker-compose up --detach $CONTAINER_NAME
if [ "$(echo $?)" -ne "0" ]; then
    exit 1
fi

# И покажем что там получилось
sudo docker-compose ps $CONTAINER_NAME

echo
echo -e "\033[1;32mThe container '$CONTAINER_NAME' started successfully\033[0m"
