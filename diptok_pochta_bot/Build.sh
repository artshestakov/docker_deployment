#!/bin/bash

CONTAINER_NAME=diptok_pochta_bot

# Переходим в директорию скрипта
cd "$(dirname "$0")"

# Удаляем папку с клонированным репозиторием (на случай если уже есть)
rm -rf rep

# Клонируем свежий репозиторий и переходим в него
git clone https://github.com/artshestakov/diptok_pochta_bot rep
cd rep

# Обновляем подмодуль
./git_submodules_update.sh

# Собираем
./Build.sh

# Забираем артефакты и чистим за собой
cp build/bin/diptok_pochta_bot ../
cp diptok_pochta_bot/bot.lang /opt/diptok_pochta_bot
cd ..

# Останавливаем контейнер и делаем чистку
sudo docker container stop $(sudo docker ps --all --quiet --filter="name=$CONTAINER_NAME")
sudo docker image rm --force $(sudo docker images --quiet $CONTAINER_NAME)
sudo docker container rm --force $(sudo docker ps --all --quiet --filter="name=$CONTAINER_NAME")

# Собираем
sudo docker build \
--no-cache \
--progress=plain \
--tag $CONTAINER_NAME .

# Запускаем
sudo docker run \
--detach \
--restart=always \
--name $CONTAINER_NAME \
--volume /opt/diptok_pochta_bot/Logs:/opt/Logs \
--volume /opt/diptok_pochta_bot/Users:/opt/Users \
--volume /opt/diptok_pochta_bot/config.ini:/opt/config.ini \
--volume /opt/diptok_pochta_bot/bot.lang:/opt/bot.lang \
$CONTAINER_NAME

# Чистим за собой артефакты
rm diptok_pochta_bot
rm -rf rep

sleep 1

# И посмотрим, что там получилось
sudo docker ps --all
