#!/bin/bash

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
mv Bin/Release/yt_dwn_bot /opt/yt_dwn_bot
mv Downloader/yt-dlp_linux /opt/yt_dwn_bot
cd ..

rm -rf rep

