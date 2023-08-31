## Плейбук для установки ClickHouse и Vector
Этот плейбук Ansible разработан для автоматизации установки и настройки сервисов ClickHouse и Vector на указанных хостах.

### Обзор плейбука
Плейбук состоит из двух play:

1. Установка ClickHouse: Этот play устанавливает пакеты ClickHouse на заданные хосты, создает базу данных и убеждается, что сервис ClickHouse запущен.
Play clickhouse cостоит из:

    * 1 handler  
    * 4 tasks  
2. Установка Vector: Этот play загружает и устанавливает пакеты Vector на указанные хосты, применяет шаблон конфигурации и убеждается, что сервис Vector запущен.
Play vector состоит из:

    * 1 handler
    * 4 tasks 

Перед запуском playbook убедитесь, что в вашем файле инвентори (prod.yml) заданы корректные имена хоста(ов) и тип подключения `ansible_connection`.

Общие параметры задаются в файлах `group_vars/clickhouse/clickhouse.yml` и `group_vars/vector/vector.yml`

	clickhouse_version: Версия пакетов ClickHouse для установки.
	clickhouse_packages: Список имен пакетов ClickHouse для загрузки и установки.
	vector_version: Версия пакетов Vector для установки.
	vector_config_dir: Директория, где будет сохранен файл конфигурации Vector.

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