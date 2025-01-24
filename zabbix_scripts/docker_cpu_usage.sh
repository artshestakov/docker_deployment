#!/bin/bash

CONTAINER_NAME=$1

# Если имя контейнера не передали - ругаемся и выходим
if [ -z "$CONTAINER_NAME" ]
then
    echo "ERROR: container name not specified."
    exit 1
fi

# Вытаскиваем потребление процессора формате 15.4%
OUTPUT_STATS=$(docker stats --all --no-stream --format "{{.CPUPerc}}" $CONTAINER_NAME)

# Убедимся, что Докер отработал без ошибок
if [ $? -ne 0 ]
then
    # При ошибке молча отдаём ноль
    echo 0

    exit 1
fi

# Удаляем символ процента и печатаем в консоль
echo "${OUTPUT_STATS//%}"

