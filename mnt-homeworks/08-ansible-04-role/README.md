# Домашнее задание к занятию 4 «Работа с roles»

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

```
---
- src: https://github.com/AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.13"
  name: clickhouse
```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
```
user1@t450s:~/devops-netology/mnt-homeworks/08-ansible-04-role/playbook$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /home/user1/devops-netology/mnt-homeworks/08-ansible-04-role/playbook/roles/clickhouse
- clickhouse (1.13) was installed successfully
- extracting lighthouse-role to /home/user1/devops-netology/mnt-homeworks/08-ansible-04-role/playbook/roles/lighthouse-role
- lighthouse-role (1.0.1) was installed successfully
- extracting vector-role to /home/user1/devops-netology/mnt-homeworks/08-ansible-04-role/playbook/roles/vector-role
- vector-role (1.0.0) was installed successfully

```
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

[Playbook](https://github.com/sda1891/devops-netology/tree/main/mnt-homeworks/08-ansible-04-role/playbook)

[Vector role](https://github.com/sda1891/vector-role)

[Lighthouse role](https://github.com/sda1891/lighthouse-role)


---

