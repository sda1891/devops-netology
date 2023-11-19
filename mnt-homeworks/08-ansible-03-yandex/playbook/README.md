## Плейбук для установки ClickHouse, Vector и Lighthouse
Этот плейбук Ansible разработан для автоматизации установки и настройки сервисов ClickHouse, Vector и Lighthouse на указанных хостах.

### Обзор плейбука
Плейбук состоит из трех play:

1. Установка ClickHouse: Этот play устанавливает пакеты ClickHouse на заданные хосты, создает базу данных и убеждается, что сервис ClickHouse запущен.
Play clickhouse cостоит из:

    * 1 handler  
    * 4 tasks  

2. Установка Vector: Этот play загружает и устанавливает пакеты Vector на указанные хосты, применяет шаблон конфигурации и убеждается, что сервис Vector запущен.
Play vector состоит из:

    * 1 handler
    * 4 tasks 

3. Установка Lighthouse: Этот play загружает файлы Lighthouse, устанавлаивает Nginx и запускает HTTP сервер.
Play lighthouse	состоит из:
	* 1 headers
	* 1 pre-tasks
	* 5 tasks

Перед запуском playbook убедитесь, что в вашем файле инвентори (prod.yml) заданы корректные имена хоста(ов) и тип подключения `ansible_connection`.

Общие параметры задаются в файлах `group_vars/clickhouse/clickhouse.yml`
`group_vars/vector/vector.yml`
`group_vars/lighthouse/lighthouse.yaml`

	clickhouse_version: Версия пакетов ClickHouse для установки.
	clickhouse_packages: Список имен пакетов ClickHouse для загрузки и установки.
	vector_version: Версия пакетов Vector для установки.
	vector_config_dir: Путь к файлу конфигурации Vector.
	nginx_user_name: Пользователь под которым выполняется процесс nginx.
	lighthouse_repo: Путь к репозиторию.
	lighthouse_path: Пусть установки.

Для установки плейбука необходимо выполнить команду:
```bash
# ansible-playbook -i inventory/prod.yml site.yml
```

Плейбук поддерживает теги для выполнения конкретных частей:

clickhouse: Установить пакеты ClickHouse и настроить базу данных.
vector: Загрузить и установить пакеты Vector, применить конфигурацию и управлять сервисом.
handlers: Перезапустить сервисы ClickHouse или Vector по мере необходимости.
Теги можно использовать для выполнения конкретных разделов плейбука. Например, чтобы установить только ClickHouse, можно выполнить:

```bash
# ansible-playbook -i inventory.yml playbook.yml --tags clickhouse
```
Или чтобы установить только Vector:

```bash
# ansible-playbook -i inventory.yml playbook.yml --tags vector
```

### Play Clickhouse
1. Загружаются rpm пакеты для установки версии, согласно переменной `{{clickhouse_version}}` в файле `./playbook/group_vars/clickhouse/clickhouse.yml`
Перечень пакетов для установки задается в `{{ clickhouse_packages }}` и подставляется зачение через `{{with_items}}` в цикле:
`ansible.builtin.get_url:`
		`url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"`
		`dest: "./{{ item }}-{{ clickhouse_version }}.rpm"`
`with_items: "{{ clickhouse_packages }}"`
2. Пакеты rpm сохраняются для последующей установки в домашнем каталоге пользователя. 
3. Производится установка пакетов с помощью вызова ansible.builtin.yum
4. По завершении установки пакетов происходит перезапуск службы `clickhouse-server`
5. Далее запускается клиент ClickHouse через ansible.builtin.command и создается БД `logs`

### Play Vector
1. Загружаются rpm пакеты для установки версии, согласно переменной `{{vector_version}}` в файле `./playbook/group_vars/vector/vars.yml`
2. Пакеты rpm сохраняются для последующей установки в домашнем каталоге пользователя. 
3. Производится установка пакетов с помощью вызова ansible.builtin.yum
4. Применяется шаблон vector.yml.j2 для создания файла к конфигурации Vector в каталоге `{{ vector_config_dir }}`, заданного в файле `./playbook/group_vars/vector/vars.yml`
5. Применяется шаблон vector.service.yml.j2 для изменения systemd unit vector.service и запускается сервис Vector.

### Play Lighthouse
1. Сначала выполняется pre-task для установки git с помощью модуля yum.
2. С помощью модкля yum устанвливаем репозиторий EPEL.
3. С помощью модуля yum устанавливаем Nginx.
4. Загружаем каталог Lighthouse с github. Все пути, отуда и куда загружать, заданы в переменных group_vars/lighthouse/lighthouse.yaml.
5. Создаем конфигурацию /etc/nginx/nginx.conf из шаблона templates/nginx.conf.j2.
6. Выполняем рестарт сервиса Nginx.