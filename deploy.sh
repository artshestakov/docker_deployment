#!/bin/bash

# Путь к файлу docker-compose.yml
COMPOSE_PATH=$1

# Убеждаемся что путь передали
if [[ -z $COMPOSE_PATH ]]; then
    echo "Path to the docker compose file is empty!"
    echo "Example: ./deploy.sh /path/to/docker-compose.yml"
    exit 1
fi

# Выкачиваем образ
docker-compose --file $COMPOSE_PATH pull

# Запускаем
docker-compose --file $COMPOSE_PATH up -d --renew-anon-volumes

# И спустя секунду смотрим на статус
docker-compose --file $COMPOSE_PATH ps --all

