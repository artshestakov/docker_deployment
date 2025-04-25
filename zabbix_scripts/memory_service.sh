#!/bin/bash

# Название сервиса
SERVICE_NAME=$1

# Убеждаемся что путь передали
if [[ -z $SERVICE_NAME ]]; then
    echo "Service name is empty!"
    echo "Example: ./memory_service.sh sshd"
    exit 1
fi

# Вытаскиваем PID процесса
PID=$(pgrep "$SERVICE_NAME")

# Вытаскиваем фактическое потребление паммяти процессом
MEMORY=$(cat /proc/$PID/status | grep -E "VmRSS" | grep -Po "\d+")

# Переводим в мегабайты, т.к. VmRSS измеряется в килобайтах
MEMORY=$(echo "$MEMORY / 1024" | bc)

echo $MEMORY

