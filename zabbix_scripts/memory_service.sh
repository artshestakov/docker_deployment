#!/bin/bash

# Название сервиса
SERVICE_NAME=$1

# Убеждаемся что путь передали
if [[ -z $SERVICE_NAME ]]; then
    echo "Service name is empty!"
    echo "Example: ./memory_service.sh sshd"
    exit 1
fi

OUTPUT=$(service $SERVICE_NAME status | grep Memory | grep -Po '\d+(,|.|null)\d+\w')

# Вытаскиваем число
MEMORY=$(echo $OUTPUT | grep -Po '^\d+(.|,)\d+')

# Вытаскиваем единицу измерения: K (kb), M (mb) или G (gb)
UNIT=$(echo $OUTPUT | grep -Po '([A-Z]+|[a-z]+)+')

# И приводим к нижнему регистру, для безопасного сравнения дальше
UNIT=$(echo "${UNIT,,}")

# Если значение пришло в килобайтах - то округляем до 1 мегабайта, чтобы не заморачиваться
if [[ "$UNIT" == "k" ]]
then
    MEMORY=1
elif [[ "$UNIT" == "g" ]] # Значение в гигабайтах - переводим в мегабайты
then
    MEMORY=$(echo "$MEMORY * 1024" | bc)
fi

echo $MEMORY
