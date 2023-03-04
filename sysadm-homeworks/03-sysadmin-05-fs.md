### 1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

	Sparse файлы содержат значительное количество нулей и хранят только непустые значения и информацию о том,
	где они находятся в файле.	Это позволяет значительно сократить размер файла и экономить место на диске. 
	Особенно это полезно при работе с большими файлами, например, в виртуальных машинах, базах данных или приложениях, 
	которые используют большие файлы данных.
	
```bash
Обычный файл заполненный нулями

root@sysadm-fs:~# dd if=/dev/zero of=output1 bs=1G count=4
4+0 records in
4+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 6.78301 s, 633 MB/s

root@sysadm-fs:~# stat output1
  File: output1
  Size: 4294967296      Blocks: 8388616    IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 1179652     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-02-21 06:10:29.703283669 +0000
Modify: 2023-02-21 06:10:35.077969826 +0000
Change: 2023-02-21 06:10:35.077969826 +0000
 Birth: -

Разреженный файл заполненный нулями

root@sysadm-fs:~# dd if=/dev/zero of=output2 bs=1G seek=0 count=0
0+0 records in
0+0 records out
0 bytes copied, 0.000329466 s, 0.0 kB/s

root@sysadm-fs:~# stat output2
  File: output2
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d    Inode: 1179653     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-02-21 07:42:34.936775866 +0000
Modify: 2023-02-21 07:42:34.936775866 +0000
Change: 2023-02-21 07:42:34.936775866 +0000
 Birth: -
```	


### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

	Не могут, это ссылки на один и тот же inode, 
	в котором хранятся права доступа и имя владельца.

### 3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

```vagrant
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
```

#### Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Сделано

```bash
root@sysadm-fs:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 67.8M  1 loop /snap/lxd/22753
loop2                       7:2    0   62M  1 loop /snap/core20/1611
loop3                       7:3    0 49.9M  1 loop /snap/snapd/18357
loop4                       7:4    0 63.3M  1 loop /snap/core20/1822
loop5                       7:5    0 91.9M  1 loop /snap/lxd/24061
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
sdc                         8:32   0  2.5G  0 disk


```	

### 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

```bash
root@sysadm-fs:~# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x53531bf5.

Command (m for help): F
Unpartitioned space /dev/sdb: 2.51 GiB, 2683305984 bytes, 5240832 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes

Start     End Sectors  Size
 2048 5242879 5240832  2.5G

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x53531bf5

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

### 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

```bash
root@sysadm-fs:~# sfdisk -d /dev/sdb > sdb.dump
root@sysadm-fs:~# sfdisk /dev/sdc < sdb.dump
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x53531bf5.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x53531bf5

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

```

### 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
```bash
root@sysadm-fs:~# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[bc]1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

```

### 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```bash
root@sysadm-fs:~# mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sd[bc]2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```
### 8. Создайте 2 независимых PV на получившихся md-устройствах.
```bash
root@sysadm-fs:~# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
root@sysadm-fs:~# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.

```

### 9. Создайте общую volume-group на этих двух PV.
```bash
root@sysadm-fs:~# vgcreate netology /dev/md0 /dev/md1
  Volume group "netology" successfully created
root@sysadm-fs:~#
root@sysadm-fs:~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  netology    2   0   0 wz--n-  <2.99g <2.99g
  ubuntu-vg   1   1   0 wz--n- <62.00g 31.00g
```

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

```bash
root@sysadm-fs:~# lvcreate -L 100m -n netology-lv netology /dev/md1
  Logical volume "netology-lv" created.
root@sysadm-fs:~#
root@sysadm-fs:~# lvs -o +devices
  LV          VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  netology-lv netology  -wi-a----- 100.00m                                                     /dev/md1(0)
  ubuntu-lv   ubuntu-vg -wi-ao---- <31.00g                                                     /dev/sda3(0)

```

### 11. Создайте `mkfs.ext4` ФС на получившемся LV.
```bash
root@sysadm-fs:~# mkfs.ext4 -L netology-ext4 -m 1 /dev/mapper/netology-netology--lv
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

```

### 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```bash
root@sysadm-fs:~# mkdir /tmp/new
root@sysadm-fs:~# mount /dev/mapper/netology-netology--lv /tmp/new/
root@sysadm-fs:~# mount | grep netology-netology--lv
/dev/mapper/netology-netology--lv on /tmp/new type ext4 (rw,relatime,stripe=256)

```


### 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```bash
root@sysadm-fs:/tmp/new# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-02-21 08:38:54--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 24753045 (24M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                           100%[======================================================================================>]  23.61M  1.51MB/s    in 19s

2023-02-21 08:39:14 (1.25 MB/s) - ‘/tmp/new/test.gz’ saved [24753045/24753045]

root@sysadm-fs:/tmp/new# ls -lah test.gz
-rw-r--r-- 1 root root 24M Feb 21 07:34 test.gz

```

### 14. Прикрепите вывод `lsblk`.
```bash
root@sysadm-fs:/tmp/new# lsblk
NAME                        MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                         7:0    0 67.8M  1 loop  /snap/lxd/22753
loop2                         7:2    0   62M  1 loop  /snap/core20/1611
loop3                         7:3    0 49.9M  1 loop  /snap/snapd/18357
loop4                         7:4    0 63.3M  1 loop  /snap/core20/1822
loop5                         7:5    0 91.9M  1 loop  /snap/lxd/24061
sda                           8:0    0   64G  0 disk
├─sda1                        8:1    0    1M  0 part
├─sda2                        8:2    0    2G  0 part  /boot
└─sda3                        8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv   253:0    0   31G  0 lvm   /
sdb                           8:16   0  2.5G  0 disk
├─sdb1                        8:17   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
└─sdb2                        8:18   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0
    └─netology-netology--lv 253:1    0  100M  0 lvm   /tmp/new
sdc                           8:32   0  2.5G  0 disk
├─sdc1                        8:33   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
└─sdc2                        8:34   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0
    └─netology-netology--lv 253:1    0  100M  0 lvm   /tmp/new

```
### 15. Протестируйте целостность файла:

```bash
root@sysadm-fs:/tmp/new# gzip -v -t /tmp/new/test.gz
	/tmp/new/test.gz:        OK
```

### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
root@sysadm-fs:/tmp/new# pvmove -n netology-lv /dev/md1 /dev/md0
  /dev/md1: Moved: 16.00%

  /dev/md1: Moved: 100.00%
root@sysadm-fs:/tmp/new#
root@sysadm-fs:/tmp/new# lvs -o +devices
  LV          VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  netology-lv netology  -wi-ao---- 100.00m                                                     /dev/md0(0)
  ubuntu-lv   ubuntu-vg -wi-ao---- <31.00g                                                     /dev/sda3(0)

```

### 17. Сделайте `--fail` на устройство в вашем RAID1 md.
```bash
root@sysadm-fs:/tmp/new# mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```
### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```bash
root@sysadm-fs:/tmp/new# dmesg | grep md0 | tail -n 2
[16008.321901] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.

```

### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

```bash
root@sysadm-fs:/tmp/new# gzip -v -t /tmp/new/test.gz
/tmp/new/test.gz:        OK
root@sysadm-fs:/tmp/new# echo $?
0
```
### 20. Погасите тестовый хост, `vagrant destroy`.
```bash
root@host:~/vagrant# vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```

