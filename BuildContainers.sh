#!/bin/bash

# Останавливаем и удаляем все контейнеры
sudo docker-compose rm --force --stop

# Выполняем сборку всех контейнеров
sudo docker-compose build --parallel --progress plain

# Запускаем
sudo docker-compose up --detach

echo
echo

# И покажем что там получилось
sudo docker-compose ps
