#coding=utf-8
import platform
import subprocess
import sys
import os
from datetime import datetime

#Функция вывода помощи по запуску скрипта
def ShowUsage():
    print("Utility for creating database backup with pg_dump")
    print("Usage: BackuperDB.py [PATH_BACKUP_DIR] [DB_NAME] [DB_PASSWORD]")
    print("Example:")
    print("    BackuperDB.py [C:\\folder OR /tmp/foler] testing_db super_password")

#Проверяем количество указанных аргументов
if len(sys.argv) != 4:
    print("Invalid arguments!");
    ShowUsage()
    sys.exit(1)

#Вытаскиваем рабочие аргументы
DirPath = sys.argv[1]
DBName = sys.argv[2]
DBPassword = sys.argv[3]

#Добавим разделитель путей, если его нет
if (DirPath[-1] != os.sep):
    DirPath += os.sep

#Формируем имя файла бекапа
FileName = DirPath + DBName + '_' + datetime.now().strftime("%Y.%m.%d_%H.%M") + ".dmp"

#Устанавливаем переменную среды для пароля (только для Windows)
if (platform.system() == "Windows"):
    os.environ["PGPASSWORD"] = DBPassword

#Формируем команду
Command = ""

if (platform.system() == "Windows"):
    Command += "pg_dump.exe "
else:
    Command += "PGPASSWORD=" + DBPassword + " pg_dump "

Command += "--host=127.0.0.1 "        # Куда подключаемся
Command += "--port=5432 "             # Порт
Command += "--username=postgres "     # Кем подключаемся
Command += "--format=c "              # Формат выводимых данных
Command += "--compress=9 "            # Уровень сжатия от 0 до 9 (9 - максимальный)
Command += "--inserts "               # Выгрузить данные в виде команд INSERT, не COPY
Command += "--column-inserts "        # Выгружать данные в виде INSERT с именами столбцов
Command += "--role=postgres "         # Выполнить SET ROLE перед выгрузкой
Command += "--verbose "               # Подробный вывод
Command += "--file=" + FileName + ' ' # Файл, куда будет выгружен дамп
Command += DBName                     # Собственно имя выгружаемой БД

print("\nCommand:\n" + Command + '\n\nProcess:')

ReturnCode = subprocess.call(Command, shell=True)
print("\nBackuperDB return code is " + str(ReturnCode))