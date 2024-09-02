#!/bin/bash

# Проверка наличия параметра
function check_parameter()
{
    # Если параметр не пустой - ругаемся и выходим из скрипта
    if [ -z "$1" ]
    then
        echo "Parameter is empty!"
        echo ""
        echo "Usage: ./backup_db.sh [HOST] [PORT] [DATABASE_NAME] [PASSWORD] [PATH_TO_BACKUP_DIR]"
        echo "Example:"
        echo "  ./backup_db.sh 127.0.0.1 5432 example_db super_pass_word /media/backup_dir_name/"
        exit 1
    fi

    # Параметр указали - все ок
}

# Проверяем наличие параметров
DB_HOST=$1
DB_PORT=$2
DB_NAME=$3
DB_PASS=$4
DIR_PATH=$5

check_parameter $DB_HOST
check_parameter $DB_PORT
check_parameter $DB_NAME
check_parameter $DB_PASS
check_parameter $DIR_PATH

# Если последний символ не является разделителем - добавим его
LAST_CHAR="${DIR_PATH: -1}"
if [[ "$LAST_CHAR" != "/" ]]
then
    DIR_PATH+="/"
fi

# Формируем путь к файлу
FILE_PATH=$DIR_PATH$DB_NAME$(date +"_%Y%m%d%H%M%S")
FILE_PATH_DMP=$FILE_PATH".dmp"
FILE_PATH_LOG=$FILE_PATH".log"

# Заполняем специальную переменную, чтобы избежать интерактива
export PGPASSWORD=$DB_PASS

# Выполняем команду
pg_dump \
  --host=$DB_HOST \
  --port=$DB_PORT \
  --username=postgres \
  --format=c --compress=9 \
  --inserts \
  --column-inserts \
  --role=postgres \
  --verbose \
  --file=$FILE_PATH_DMP \
  $DB_NAME >> $FILE_PATH_LOG 2>&1 #Перехват STDERR

# Проверим, а без ошибок ли выполнилась наша команда
if [ $? -eq 0 ]
then
    echo "The backup was created successfully!"
    echo "Dump path: ${FILE_PATH_DMP}"
    echo "Log path:  ${FILE_PATH_LOG}"
else
    echo "Can't create a backup!"
    echo "Check log file by path ${FILE_PATH_LOG}"

    # При ошибке отдаём наверх ошибочный код, на случай если нас запускают из чужого скрипта
    exit 1
fi
