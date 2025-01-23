#!/bin/bash

# Для арифметики с плавающей точкой нам нужна утилита bc.
# Проверим её наличие в системе
bc --help > /dev/null 2>&1

if [ $? -ne 0 ]
then
    # Утилиты нет - ругаемся и выходим

    echo "ERROR: \"bc\" package does not exist in the system. Install it and try again."
    exit 1
fi

CONTAINER_NAME=$1

# Если имя контейнера не передали - ругаемся и выходим
if [ -z "$CONTAINER_NAME" ]
then
    echo "ERROR: container name not specified."
    exit 1
fi

# Вытаскиваем потребление памяти в формате N[KiB|MiB|GiB] / [LIMIT]
# Где: N - используемая память

OUTPUT_STATS=$(sudo docker stats --all --no-stream --format "{{.MemUsage}}" $CONTAINER_NAME)

# Убедимся, что Докер отработал без ошибок
if [ $? -ne 0 ]
then
    # При ошибке молча отдаём ноль
    echo 0

    exit 1
fi

# Забираем используемую память (левая часть) из уебанского вывода
OUTPUT_STATS=$(echo $OUTPUT_STATS | grep -Po '^\d+(.|,)\d+([A-Z]+|[a-z]+)+')

# Вытаскиваем число
MEMORY=$(echo $OUTPUT_STATS | grep -Po '^\d+(.|,)\d+')

# Вытаскиваем постфикс: KiB, MiB или GiB
POSTFIX=$(echo $OUTPUT_STATS | grep -Po '([A-Z]+|[a-z]+)+')

# И приводим к нижнему регистру, для безопасного сравнения дальше
POSTFIX=$(echo "${POSTFIX,,}")

# Если значение пришло в килобайтах - то округляем до 1 мегабайта, чтобы не заморачиваться
if [[ "$POSTFIX" == "kib" ]]
then
    MEMORY=1
elif [[ "$POSTFIX" == "gib" ]] # Значение в гигабайтах - переводим в мегабайты
then
    MEMORY=$(echo "$MEMORY * 1024" | bc)
fi

echo $MEMORY

