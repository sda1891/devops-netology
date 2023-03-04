## Задание 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "7175"
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }

```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import json
import yaml

JSON_FILE_NAME = "services.json"
YAML_FILE_NAME = "services.yml"
try:
    with open(JSON_FILE_NAME, "r") as f:
        services_json = json.load(f)
except FileNotFoundError:
    services_json = {}
try:
    with open(YAML_FILE_NAME, "r") as f:
        services_yaml = yaml.safe_load(f)
except FileNotFoundError:
    services_yaml = {}

services = {**services_json, **services_yaml}
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

with open(JSON_FILE_NAME, "w") as f:
    json.dump(services, f)

with open(YAML_FILE_NAME, "w") as f:
    yaml.dump(services, f)

```

### Вывод скрипта при запуске при тестировании:
```
user1@t450s:~$ ./http_svc_check.v2.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.18 64.233.161.83
[ERROR] google.com IP mismatch: 173.194.73.138 173.194.73.102
user1@t450s:~$ cat services.yml
drive.google.com: 64.233.164.194
google.com: 173.194.73.102
mail.google.com: 64.233.161.83
user1@t450s:~$ cat services.json
{"drive.google.com": "64.233.164.194", "mail.google.com": "64.233.161.83", "google.com": "173.194.73.102"}
user1@t450s:~$

user1@t450s:~$ ./http_svc_check.v2.py
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 64.233.161.83 64.233.161.19
[ERROR] google.com IP mismatch: 173.194.73.102 173.194.73.113
user1@t450s:~$ cat services.yml
drive.google.com: 64.233.164.194
google.com: 173.194.73.113
mail.google.com: 64.233.161.19
user1@t450s:~$ cat services.json
{"drive.google.com": "64.233.164.194", "mail.google.com": "64.233.161.19", "google.com": "173.194.73.113"}

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
user1@t450s:~$ cat services.json
{"drive.google.com": "64.233.164.194", "mail.google.com": "64.233.161.19", "google.com": "173.194.73.113"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
user1@t450s:~$ cat services.yml
drive.google.com: 64.233.164.194
google.com: 173.194.73.113
mail.google.com: 64.233.161.19
```

---

