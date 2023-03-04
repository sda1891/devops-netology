### 1. Какой системный вызов делает команда `cd`? 

    Выполняется chdir(<path>) 

### 2. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:
```bash
user1@vmhost:~$ file /dev/tty
/dev/tty: character special (5/0)
user1@vmhost:~$ file /dev/sda
/dev/sda: block special (8/0)
user1@vmhost:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=33a5554034feb2af38e8c75872058883b2988bc5, for GNU/Linux 3.2.0, stripped
	
```

###### Используя `strace` выясните, где находится база данных 'file', на основании которой она делает свои догадки.
	
	openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
	openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3


### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

```trancatedel

root@vmhost:~# lsof |grep dele|grep log
lsof: WARNING: can't stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
      Output information may be incomplete.
lsof: WARNING: can't stat() fuse.portal file system /run/user/1000/doc
      Output information may be incomplete.
gnome-she  1578                             user1   55r      REG                8,5    32768    1966163 /home/user1/.local/share/gvfs-metadata/root-7cc952b1.log (deleted)
gnome-she  1578  1622 JS\x20Hel             user1   55r      REG                8,5    32768    1966163 /home/user1/.local/share/gvfs-metadata/root-7cc952b1.log (deleted)
gnome-she  1578  3176 threaded-             user1   55r      REG                8,5    32768    1966163 /home/user1/.local/share/gvfs-metadata/root-7cc952b1.log (deleted)

root@t450s:~# ls -lah /proc/1578/fd/|grep log
lr-x------ 1 user1 user1 32K фев 18 19:23 55 -> /home/user1/.local/share/gvfs-metadata/root-7cc952b1.log (deleted)
lr-x------ 1 user1 user1 64 фев 18 19:23 94 -> /home/user1/.local/share/gvfs-metadata/trash:-1a89f5bf.log

root@vmhost:~# echo '' > /proc/1578/fd/55

```
#### echo '' > /proc/\<pid>/fd/\<deleted file descriptor>

### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

	Зомби-процессы занимают ресурсы в операционной системе (ОС), 
	но в незначительной степени.

	Когда процесс завершается, но родительский процесс 
	не вызывает функцию wait() или waitpid() для получения статуса завершения, 
	процесс становится зомби-процессом. 
	Зомби-процесс не занимает никаких ресурсов, 
	кроме записи в таблицу процессов, 
	которая содержит информацию о статусе процесса и других свойствах.
	Зомби-процесс не использует процессорное время и не занимает оперативную память.

	Однако зомби-процесс может занимать некоторые ресурсы, 
	если родительский процесс не обрабатывает его статус завершения в течение длительного времени. 
	Когда число зомби-процессов становится большим, таблица процессов может исчерпать свои ресурсы, 
	что может привести к проблемам в работе операционной системы. 
	Поэтому важно обрабатывать статус завершения процессов, 
	чтобы избежать накопления зомби-процессов.

### 5. В iovisor BCC есть утилита `opensnoop`:
```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
```
##### На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты?

```opensnoop
user1@vmhost:~$ sudo opensnoop-bpfcc
[sudo] пароль для user1:
PID    COMM               FD ERR PATH
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.pressure
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.current
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.min
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.low
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.swap.current
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.stat
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.pressure
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.current
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.min
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.low
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.swap.current
422    systemd-oomd        7   0 /sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/memory.stat
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo
422    systemd-oomd        7   0 /proc/meminfo


```	


### 6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

	Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

### 7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
	";" указывает на то, что следующая команда должна быть выполнена независимо от того, была ли предыдущая команда выполнена успешно или нет. То есть команды, разделенные символом ";", будут выполняться независимо от результата выполнения предыдущей команды.
	
	"&&" указывает на то, что следующая команда должна быть выполнена только в том случае, если предыдущая команда была выполнена успешно. Если же предыдущая команда завершилась с ошибкой, следующая команда не будет выполнена.
	
##### Есть ли смысл использовать в bash `&&`, если применить `set -e`?
	"set -e" прерывает выполнение скрипта при возникновении ошибки в любой из команд скрипта, т.е. если команда command1 завершится с ошибкой, 
	выполнение скрипта остановится и команда command2 не будет выполнена
	"&&" позволяет выполнить следующую команду только в случае успешного выполнения предыдущей.	
	
	Использование "&&" вместе с "set -e" может быть полезным для выполнения команд в определенном порядке и контроля за ошибками в скрипте
		
		

### 8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

	-e  Exit immediately if a command exits with a non-zero status.
	-u  Treat unset variables as an error when substituting.
	-x  Print commands and their arguments as they are executed.
	-o  pipefail the return value of a pipeline is the status of
        the last command to exit with a non-zero status,
        or zero if no command exited with a non-zero status
	
	Повышает детализацию вывода ошибок и завершит сценарий при наличии ошибок, 
	на любом этапе выполнения сценария, кроме последней завершающей команды.
	
### 9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

```bash

~ ps -Ao stat  | sort | uniq -c | sort -h-h
      1 R+
      1 S<
      1 Sl+
      1 S<s
      1 Ssl+
      1 STAT
      2 SN
      2 SNsl
      2 S<sl
      6 S+
     14 I
     24 Sl
     34 Ss
     46 I<
     53 Ssl
     61 S


```	
S - процессы в режиме ожидания

I - фоновые процессы ядра