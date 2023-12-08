## Плейбук для установки ClickHouse, Vector и Lighthouse
Этот плейбук Ansible разработан для автоматизации установки и настройки сервисов ClickHouse, Vector и Lighthouse на указанных хостах.

### Обзор плейбука
Плейбук состоит из трех play:

1. Установка ClickHouse: Этот play устанавливает пакеты ClickHouse на заданные хосты, создает базу данных и убеждается, что сервис ClickHouse запущен.

2. Установка Vector: Этот play загружает и устанавливает пакеты Vector на указанные хосты, применяет шаблон конфигурации и убеждается, что сервис Vector запущен.

3. Установка Lighthouse: Этот play загружает файлы Lighthouse, устанавлаивает Nginx и запускает HTTP сервер.

Перед запуском playbook убедитесь:
- что в вашем файле инвентори (prod.yml) заданы корректные имена хоста(ов) и тип подключения `ansible_connection`.
- выполнена установка ролей (ansible-galaxy install -r requirements.yml -p roles)


Общие параметры задаются в файлах defaults/main.yml и vars/main.yml в каталогах установленных ролей.

Для установки плейбука необходимо выполнить команду:
```bash
# ansible-playbook -i inventory/prod.yml site.yml
```
