## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | будет вызвано исключение TypeError, так как операция сложения не определена для типов int и str. - переменная "c" не будет иметь никакого значения.  |
| Как получить для переменной `c` значение 12?  | необходимо изменить тип переменной "b" на int  |
| Как получить для переменной `c` значение 3?  | необходимо преобразовать значение переменной "a" в строку и выполнить конкатенацию строк  |

------
## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3
import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os

repo_path = "/home/user1/devops-netology/"
bash_command = ["git --git-dir={}/.git --work-tree={} status".format(repo_path, repo_path)]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if 'modified:' in result.split():
        prepare_result = result.strip().split('modified:')[1].strip()
        print("Modified file detected:")
        print(os.path.join(repo_path, prepare_result))
        is_change = True
if not is_change:
    print("No modified files detected.")

```

### Вывод скрипта при запуске при тестировании:
```
user1@t450s:~$ ./check_repo.py
Modified file detected:
/home/user1/devops-netology/README.md

```
------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import argparse

parser = argparse.ArgumentParser(description='Check for modified files in a Git repository')
parser.add_argument('repo_path', type=str, help='Path to the Git repository')

args = parser.parse_args()

bash_command = ["git --git-dir={}/.git --work-tree={} status".format(args.repo_path, args.repo_path)]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if 'modified:' in result.split():
        prepare_result = result.strip().split('modified:')[1].strip()
        print("Modified file detected:")
        print(os.path.join(args.repo_path, prepare_result))
        is_change = True
if not is_change:
    print("No modified files detected.")

```

### Вывод скрипта при запуске при тестировании:
```
user1@t450s:~$ ./check_repo.v2.py /home/user1/devops-netology
Modified file detected:
/home/user1/devops-netology/README.md

```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import json

FILE_NAME = "services.json"
try:
    with open(FILE_NAME, "r") as f:
        services = json.load(f)
except FileNotFoundError:
    services = {}
for service, old_ip in services.items():
    try:
        ip = socket.gethostbyname(service)
        if old_ip and old_ip != ip:
            print(f"[ERROR] {service} IP mismatch: {old_ip} {ip}")
        else:
            print(f"{service} - {ip}")
        services[service] = ip
    except socket.error:
        print(f"[ERROR] {service} is unavailable")
with open(FILE_NAME, "w") as f:
    json.dump(services, f)

```

### Вывод скрипта при запуске при тестировании:
```
user1@t450s:~$ echo '{"drive.google.com": "64.233.164.194", "mail.google.com": "64.233.161.83", "google.com": "173.194.73.102"}' >> services.json

user1@t450s:~$ ./http_svc_check.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.83 64.233.161.19
[ERROR] google.com IP mismatch: 173.194.73.101 173.194.73.102

user1@t450s:~$ ./http_svc_check.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.19 64.233.161.18
google.com - 173.194.73.102

user1@t450s:~$ ./http_svc_check.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.18 64.233.161.19
[ERROR] google.com IP mismatch: 173.194.73.102 173.194.73.100

user1@t450s:~$ ./http_svc_check.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.19 64.233.161.83
[ERROR] google.com IP mismatch: 173.194.73.100 173.194.73.102

```

------



