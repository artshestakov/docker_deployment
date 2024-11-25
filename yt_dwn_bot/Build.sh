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

# Делаем резервную копию
cp /opt/yt_dwn_bot/yt_dwn_bot /opt/yt_dwn_bot/yt_dwn_bot.backup

# Забираем бинарники и чистим за собой
mv Bin/Release/yt_dwn_bot /opt/yt_dwn_bot
mv Bin/Release/yt-dlp_linux /opt/yt_dwn_bot
cp kill.sh /opt/yt_dwn_bot
cp Lang/English.lang /opt/yt_dwn_bot/bot.lang
cd ..

rm -rf rep

