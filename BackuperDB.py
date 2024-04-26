#coding=utf-8
import platform
import subprocess
import sys
import os
import time
from datetime import datetime

# Функция вывода помощи по запуску скрипта
def ShowUsage():
    print("Utility for creating database backup with pg_dump")
    print("Usage: BackuperDB.py [PATH_BACKUP_DIR] [DB_NAME] [DB_PASSWORD]")
    print("Example:")
    print("    BackuperDB.py [C:\\folder OR /tmp/foler] testing_db super_password")

# Проверка существования файла
def FileExists(file_path):
    if os.path.exists(file_path):
        print("File \"" + file_path + "\" is exists!")
        sys.exit(1)

# Создание директории, если ещё не существует
def DirCreate(dir_path):
    if not os.path.exists(dir_path):
        os.mkdir(dir_path)

# НАЧАЛО СКРИПТА

# Проверяем количество указанных аргументов
if len(sys.argv) != 4:
    print("Invalid arguments!")
    ShowUsage()
    sys.exit(1)

# Вытаскиваем рабочие аргументы
dir_path = sys.argv[1]
db_name = sys.argv[2]
db_password = sys.argv[3]

# Добавим разделитель путей, если его нет
if (dir_path[-1] != os.sep):
    dir_path += os.sep

DirCreate(dir_path)

# Формируем имена файлов
file_name = dir_path + db_name + '_' + datetime.now().strftime("%Y.%m.%d_%H.%M")
file_name_dmp = file_name + ".dmp"
file_name_log = file_name + ".log"

# Проверим, не существуют ли уже файлы
FileExists(file_name_dmp)
FileExists(file_name_log)

# Формируем команду
cmd = str()

if (platform.system() == "Windows"):
    os.environ["PGPASSWORD"] = db_password
    cmd += "pg_dump.exe "
else:
    cmd += "PGPASSWORD=" + db_password + " pg_dump "

cmd += "--host=127.0.0.1 "             # Куда подключаемся
cmd += "--port=5432 "                  # Порт
cmd += "--username=postgres "          # Кем подключаемся
cmd += "--format=c "                   # Формат выводимых данных
cmd += "--compress=9 "                 # Уровень сжатия от 0 до 9 (9 - максимальный)
cmd += "--inserts "                    # Выгрузить данные в виде команд INSERT, не COPY
cmd += "--column-inserts "             # Выгружать данные в виде INSERT с именами столбцов
cmd += "--role=postgres "              # Выполнить SET ROLE перед выгрузкой
cmd += "--verbose "                    # Подробный вывод
cmd += "--file=" + file_name_dmp + ' ' # Файл, куда будет выгружен дамп
cmd += db_name                         # Собственно имя выгружаемой БД
cmd += " > " + file_name_log + " 2>&1" # Перехват stderr и запись вывода в лог-файл

print("Run command:\n" + cmd)

time_start = time.time()
res = subprocess.call(cmd, shell=True)
time_end = time.time() - time_start

# Допишем служебную информацию в лог файл
if res == 0:
    elapsed = "{:.3f} msec".format(time_end)
    print("Command success for " + elapsed)

    file_log = open(file_name_log, "a")
    file_log.write("\n")
    file_log.write("Elapsed time: " + elapsed)
    file_log.close()
else:
    print("Command failure. Check the file \"" + file_name_log + "\"")
    sys.exit(1)

# Проверим, не надо ли нам почистить директорию
