#!/bin/bash

# Имя репозитория (и исполняемого файла в т.ч.)
REPO_NAME=$1

# Имя папки для деплоя
DIR_NAME=deploy_$REPO_NAME

# Проверяем, что имя передали
if [[ -z $REPO_NAME ]]; then
    echo "Argument is empty!"
    echo "Example: ./deploy.sh [repo_name]"
    exit 1
fi

# Удаляем папку с клонированным репозиторием (на случай если уже есть)
rm -rf $DIR_NAME

# Создаем папку
mkdir deploy_$REPO_NAME

# Переходим в директорию скрипта
cd $DIR_NAME

# Скачиваем последний релиз и делаем бинарник исполняемым
gh release download --repo artshestakov/$REPO_NAME --pattern $REPO_NAME
chmod +x $REPO_NAME

# Копируем бинарник и чистим за собой
mv serious_wolf_bot /opt/serious_wolf_bot
cd ..

rm -rf $DIR_NAME

