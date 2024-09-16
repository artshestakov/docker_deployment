#!/bin/bash

# Запускаем сервис
sudo service log_store restart

# И через секунду проверяем его статус
sleep 1
sudo service log_store status

