# Ansible Role:  Lighthouse
Installs and configures Lightweight interface for ClickHouse

## Description

Deploy [lighthouse](https://github.com/sda1891/lighthouse-role.git) using ansible.

## Requirements

- Ansible >= 2.10 (It might work on previous versions, but we cannot guarantee it)

## Support platform
--------

| Name | Version |
| :----: | :-----:|
| Centos| 7,8|
| Rhel | 7,8 |

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.
All variables which can be overridden are stored in [defaults/main.yml](defaults/main.yml) file as well as in table below.

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `nginx_user_name` | "nginx" | The user under which the process runs |
| `lighthouse_repo` | "https://github.com/vkcom/lighthouse" | Project home site |
| `lighthouse_path` | "/usr/share/nginx/html/lighthouse" | Installation path for lighthouse |


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
```yaml
    - hosts: servers
      roles:
         - role: lighthouse
```

License
-------

MIT

Author Information
------------------

dsa1891
