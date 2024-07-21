#!/bin/bash

# Переходим в директорию скрипта
cd "$(dirname "$0")"

# Удаляем папку с клонированным репозиторием (на случай если уже есть)
rm -rf rep

# Клонируем свежий репозиторий и переходим в него
git clone https://github.com/artshestakov/pmake_bot rep
cd rep

# Обновляем подмодуль
./git_submodules_update.sh

# Собираем
./Build.sh

# Забираем бинарники и чистим за собой
mv Bin/Release/pmake_bot /opt/pmake_bot
cd ..

rm -rf rep

