#!/bin/bash

CONTAINER_NAME=yt_dwn_bot

# Переходим в директорию скрипта
cd "$(dirname "$0")"

# Удаляем папку с клонированным репозиторием (на случай если уже есть)
rm -rf rep

# Клонируем свежий репозиторий и переходим в него
git clone https://github.com/artshestakov/yt_dwn_bot rep
cd rep

# Обновляем подмодуль
./git_submodules_update.sh

# Собираем
./Build.sh

# Забираем бинарники и чистим за собой
cp build/bin/yt_dwn_bot ../
cp Downloader/yt-dlp_linux ../
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
--volume /opt/yt_dwn_bot/Logs:/opt/Logs \
--volume /opt/yt_dwn_bot/History:/opt/History \
--volume /opt/yt_dwn_bot/config.ini:/opt/config.ini \
--volume /etc/timezone:/etc/timezone \
--name $CONTAINER_NAME \
$CONTAINER_NAME

# Чистим за собой артефакты
rm yt_dwn_bot
rm yt-dlp_linux
rm -rf rep

sleep 1

# И посмотрим, что там получилось
sudo docker ps --all
