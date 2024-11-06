#!/bin/bash

# ##############################################
# Зависимости скрипта: gh, jq
#
# Перед использованием программы в gh нужно залогиниться,
# т.е. выполнить комманду 'gh auth login' и убедиться,
# что у вас настроен доступ к Github по ключу ssh.
# ##############################################

GITHUB_PATH=$1
TARGET_PATH=$2

# Убедимся, что нам подали путь к папке, куда мы будем клонировать репозитории
if [[ -z $GITHUB_PATH ]]; then
    echo "Github path is not specified. Example: backup_github.cmd /path/to/github_repo /path/to/storage"
    exit 1
fi

# И не забываем про целевую папку, иначе некуда будет перемещать архивы
if [[ -z $TARGET_PATH ]]; then
    echo "Target path is not specified. Example: backup_github.cmd /path/to/github_repo /path/to/storage"
    exit 1
fi

# Если последний символ не является разделителем - добавим его
LAST_CHAR="${GITHUB_PATH: -1}"
if [[ "$LAST_CHAR" != "/" ]]
then
    GITHUB_PATH+="/"
fi

# Вытаскиваем список репозиториев в формате:
#
# [
#     {
#         "name": "[Имя репозиория]"
#         "url": "[URL-ссылка на репозиторий]"
#     }
# ]
JSON_ARRAY=$(gh repo list --json url,name)

# Получаем путь к текущей папке
CURRENT_PATH=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")

# Насильно создаём папку для репозиториев, чтобы не городить условие
mkdir -p $GITHUB_PATH

# Пробегаемся по JSON и вытаскиваем значения поля "url"
for row in $(echo "${JSON_ARRAY}" | jq -r '.[] | @base64'); do
    _jq()
    {
        echo ${row} | base64 --decode | jq -r ${1}
    }

    # Сформируем переменные для работы
    URL=$(_jq '.url')
    NAME=$(_jq '.name')
    REPO_DIR_PATH=$GITHUB_PATH$NAME

    # Для удобства просмотра вывода
    echo ""
    echo "Process of: $NAME"

    # Проверим, не существует ли уже папка с репозиторием.
    # Если существует - репозиторий уже клонировали - не насилуем диск и делаем pull

    if [ -d "$REPO_DIR_PATH" ]; then

        # Заходим в папку с репозиторием
        cd $REPO_DIR_PATH

        # И обновляем его (с подмодулями)
        git pull --recurse-submodules

        # И не забываем вернуться обратно (в папку со скриптом)
        cd $CURRENT_PATH

    else # Папка с репозиторием ещё не существует - делаем полное клонирование с подмодулями

        git clone --recurse-submodules $URL $REPO_DIR_PATH

    fi

    # Архивируем папку
    tar -cf $GITHUB_PATH$NAME.tar -C $REPO_DIR_PATH .

    # И перемещаем её куда нам сказали
    mv --force $GITHUB_PATH$NAME.tar $TARGET_PATH

done

echo ""

