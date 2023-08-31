# Домашнее задание к занятию 2 «Работа с Playbook»

1. Подготовьте свой inventory-файл `prod.yml`.

		Подготовлено окружение и файл prod.xml.

```bash
root@t450s:/home/user1/devops-netology# docker ps
CONTAINER ID   IMAGE                   COMMAND        CREATED        STATUS        PORTS     NAMES
fccae6aa28ed   centos7-systemd:my.v6   "/sbin/init"   40 hours ago   Up 40 hours             vector-01
5c06e460361f   centos7-systemd:my.v6   "/sbin/init"   47 hours ago   Up 47 hours             clickhouse-01

root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# cat inventory/prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker


vector:
  hosts:
    vector-01:
      ansible_connection: docker
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2.

		Добавил еще один play
```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-playbook -i inventory/prod.yml site.yml --list-tasks

playbook: site.yml

  play #1 (clickhouse): Install Clickhouse      TAGS: [clickhouse]
    tasks:
      Get clickhouse distrib    TAGS: [clickhouse]
      Install clickhouse packages       TAGS: [clickhouse]
      Flush handlers    TAGS: [clickhouse]
      Create database   TAGS: [clickhouse]

  play #2 (vector): Install Vector      TAGS: [vector]
    tasks:
      Download Vector packages  TAGS: [vector]
      Install Vector packages   TAGS: [vector]
      Apply Vector template     TAGS: [vector]
      Change Vector systemd unit        TAGS: [vector]

```

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

		Сделано.

4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
		
		Сделано
```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Flush handlers] *********************************************************************************************************************************************************************
RUNNING HANDLER [Start clickhouse service] ***********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Download Vector packages] ***********************************************************************************************************************************************************
changed: [vector-01]

TASK [Install Vector packages] ************************************************************************************************************************************************************
changed: [vector-01]

TASK [Apply Vector template] **************************************************************************************************************************************************************
changed: [vector-01]

TASK [Change Vector systemd unit] *********************************************************************************************************************************************************
changed: [vector-01]

RUNNING HANDLER [Start Vector service] ****************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP ********************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```		

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-lint site.yml
WARNING  Listing 9 violation(s) that are fatal
name[missing]: All tasks should be named.
site.yml:11 Task/Handler: block/always/rescue

risky-file-permissions: File permissions unset or incorrect.
site.yml:12 Task/Handler: Get clickhouse distrib

risky-file-permissions: File permissions unset or incorrect.
site.yml:18 Task/Handler: Get clickhouse distrib

fqcn[action-core]: Use FQCN for builtin module actions (meta).
site.yml:30 Use `ansible.builtin.meta` or `ansible.legacy.meta` instead.

jinja[spacing]: Jinja2 spacing could be improved: create_db.rc != 0 and create_db.rc !=82 -> create_db.rc != 0 and create_db.rc != 82 (warning)
site.yml:32 Jinja2 template rewrite recommendation: `create_db.rc != 0 and create_db.rc != 82`.

risky-file-permissions: File permissions unset or incorrect.
site.yml:46 Task/Handler: Vector | Download packages

yaml[trailing-spaces]: Trailing spaces
site.yml:50

yaml[trailing-spaces]: Trailing spaces
site.yml:55

yaml[trailing-spaces]: Trailing spaces
site.yml:75

Read documentation for instructions on how to ignore specific rule violations.

                    Rule Violation Summary
 count tag                    profile    rule associated tags
     1 jinja[spacing]         basic      formatting (warning)
     1 name[missing]          basic      idiom
     3 yaml[trailing-spaces]  basic      formatting, yaml
     3 risky-file-permissions safety     unpredictability
     1 fqcn[action-core]      production formatting

Failed: 8 failure(s), 1 warning(s) on 1 files. Last profile that met the validation criteria was 'min'.
```
	Исправил ошибки
```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-lint site.yml

Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

		Запуск check выполняется неуспешно в задаче загрузки пакетов ClickHouse, где должен отработать блок rescue. На реальном запуске playbook отработка rescue проходит нормально.

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

		Запустил, убедился.

```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] **********************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ******************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ******************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] **************************************************************************************************************************************

TASK [Create database] *************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] **************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Download packages] **************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install packages] ***************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Apply template] *****************************************************************************************************************************
ok: [vector-01]

TASK [Vector | change systemd unit] ************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

		Результат выполнения повторяется.

```bash
root@t450s:/home/user1/devops-netology/mnt-homeworks/08-ansible-02-playbook/playbook# ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] **********************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ******************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ******************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] **************************************************************************************************************************************

TASK [Create database] *************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] **************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Download packages] **************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Install packages] ***************************************************************************************************************************
ok: [vector-01]

TASK [Vector | Apply template] *****************************************************************************************************************************
ok: [vector-01]

TASK [Vector | change systemd unit] ************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook).

	Подготовил [README](https://github.com/sda1891/devops-netology/blob/main/mnt-homeworks/08-ansible-02-playbook/playbook/README.md)


10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
