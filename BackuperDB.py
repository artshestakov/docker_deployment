# coding=utf-8
import platform
import subprocess
import sys
import os
import time
import pathlib
import datetime
# -----------------------------------------------------------------------------------------------
SAVE_LAST_AMOUNT = 14  # Кол-во файлов, которые будут храниться


def show_usage():  # Функция вывода помощи по запуску скрипта
    print("Utility for create a database backup by pg_dump")
    print("Usage: BackuperDB.py [PATH_BACKUP_DIR] [DB_HOST] [DB_PORT] [DB_NAME] [DB_PASSWORD]")
    print("")
    print("Example:")
    print("  BackuperDB.py [C:\\folder OR /tmp/folder] 127.0.0.1 5432 testing_db super_password")


def get_file_size(file_path):  # Получить размер файла
    size = os.path.getsize(file_path)
    if size < 1024:
        return f"{size} bytes"
    elif size < pow(1024, 2):
        return f"{round(size / 1024, 2)} KB"
    elif size < pow(1024, 3):
        return f"{round(size / (pow(1024, 2)), 2)} MB"
    elif size < pow(1024, 4):
        return f"{round(size / (pow(1024, 3)), 2)} GB"


# Проверяем количество указанных аргументов
if len(sys.argv) != 6:
    print("Invalid arguments!")
    show_usage()
    sys.exit(1)

# Вытаскиваем рабочие аргументы
dir_path = sys.argv[1]
db_host = sys.argv[2]
db_port = sys.argv[3]
db_name = sys.argv[4]
db_password = sys.argv[5]

# Добавим разделитель путей, если его нет
if dir_path[-1] != os.sep:
    dir_path += os.sep

# Создаём директорию, если ещё не существует
if not os.path.exists(dir_path):
    os.mkdir(dir_path)

# Формируем имена файлов
file_path_dmp = dir_path + db_name + '_' + datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + ".dmp"
file_path_log = str(pathlib.Path(sys.argv[0]).parent) + os.sep + os.path.basename(sys.argv[0]).split('.')[0] + ".log"

os.environ["PGPASSWORD"] = db_password

# Формируем команду
cmd = "pg_dump "
cmd += "--host=" + db_host + ' '         # Куда подключаемся
cmd += "--port=" + db_port + ' '         # Порт
cmd += "--username=postgres "            # Кем подключаемся
cmd += "--format=c "                     # Формат выводимых данных
cmd += "--compress=9 "                   # Уровень сжатия от 0 до 9 (9 - максимальный)
cmd += "--inserts "                      # Выгрузить данные в виде команд INSERT, не COPY
cmd += "--column-inserts "               # Выгружать данные в виде INSERT с именами столбцов
cmd += "--role=postgres "                # Выполнить SET ROLE перед выгрузкой
cmd += "--verbose "                      # Подробный вывод
cmd += "--file=" + file_path_dmp + ' '   # Файл, куда будет выгружен дамп
cmd += db_name                           # Собственно имя выгружаемой БД
cmd += " >> " + file_path_log + " 2>&1"  # Перехват stderr и запись вывода в лог-файл

print("Run command:\n" + cmd)

time_start = time.time()
res = subprocess.call(cmd, shell=True)

# Допишем служебную информацию в лог файл
if res == 0:
    elapsed = "{:.3f} msec".format(time.time() - time_start)
    print("Command success for " + elapsed)

    file_log = open(file_path_log, "a")
    file_log.write("\n")
    file_log.write("Command: " + cmd + '\n')
    file_log.write("Elapsed time: " + elapsed + '\n')
    file_log.write("DMP file: " + file_path_dmp + '\n')
    file_log.write("File size: " + get_file_size(file_path_dmp) + '\n')
    file_log.write("===========================================================\n\n")
    file_log.close()
else:
    print("Command failure. Check the file \"" + file_path_log + "\"")
    sys.exit(1)

# Почистим директорию от старых файлов
dir_files = os.listdir(dir_path)
dir_files.sort()
del_amount = len(dir_files) - SAVE_LAST_AMOUNT  # Сколько нужно удалить файлов

for i in range(del_amount):
    os.remove(dir_path + dir_files[i])
