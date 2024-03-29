# 1.  Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
Win - ipconfig /all
Lin - ifcofnig, ip -br a, ip -br l

~ipconfig /all

---cut--

Адаптер беспроводной локальной сети Беспроводная сеть:

   DNS-суффикс подключения . . . . . :
   Описание. . . . . . . . . . . . . : Intel(R) Dual Band Wireless-AC 8265
   Физический адрес. . . . . . . . . : D0-C6-37-82-B3-33
   DHCP включен. . . . . . . . . . . : Нет
   Автонастройка включена. . . . . . : Да
   IPv4-адрес. . . . . . . . . . . . : 192.168.1.56(Основной)
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . : 192.168.1.1
   DNS-серверы. . . . . . . . . . . : 192.168.1.1
   NetBios через TCP/IP. . . . . . . . : Включен



# 2.  Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
LLDP. 
CentOS - lldpad.x86_64 : Intel LLDP Agent

# 3.  Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
dot1q или 802.1q (vlan tag). vlan. 

~ ip -br l
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>

---cut---

ens1f0           UP             90:e2:ba:dc:f6:bc <BROADCAST,MULTICAST,UP,LOWER_UP>

---cut---

vlan820@ens1f0   UP             90:e2:ba:dc:f6:bc <BROADCAST,MULTICAST,UP,LOWER_UP>

---cut---

~ cat /etc/sysconfig/network-scripts/ifcfg-vlan874

VLAN=yes

TYPE=Vlan

PHYSDEV=ens1f0

VLAN_ID=874

REORDER_HDR=yes

GVRP=no

MVRP=no

HWADDR=

PROXY_METHOD=none

BROWSER_ONLY=no

BOOTPROTO=none

IPADDR=*************

PREFIX=24

DEFROUTE=no

PEERROUTES=no

IPV4_FAILURE_FATAL=yes

IPV6INIT=yes

IPV6_AUTOCONF=yes

IPV6_DEFROUTE=yes

IPV6_FAILURE_FATAL=no

IPV6_ADDR_GEN_MODE=stable-privacy

NAME=vlan874

UUID=*****************************

DEVICE=vlan874

ONBOOT=yes




# 4.  Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
Бондинг.  

mode=0 (balance-rr)
Этот режим используется по-умолчанию, если в настройках не указано другое. 
balance-rr обеспечивает балансировку нагрузки и отказоустойчивость. 
В данном режиме пакеты отправляются "по кругу" от первого интерфейса к последнему и сначала. 
Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся.
При подключении портов к разным коммутаторам, требует их настройки.

mode=1 (active-backup)
При active-backup один интерфейс работает в активном режиме, остальные в ожидающем. 
Если активный падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.

mode=2 (balance-xor)
Передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) 
XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. 
Режим даёт балансировку нагрузки и отказоустойчивость.

mode=3 (broadcast)
Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.

mode=4 (802.3ad)
Это динамическое объединение портов. В данном режиме можно получить значительное увеличение пропускной способности 
как входящего так и исходящего трафика, используя все объединенные интерфейсы. 
Требует поддержки режима от коммутатора, а так же (иногда) дополнительную настройку коммутатора.

mode=5 (balance-tlb)
Адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается только активным интерфейсом, 
исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. 
Обеспечивается отказоустойчивость и распределение нагрузки исходящего трафика. 
Не требует специальной поддержки коммутатора.

mode=6 (balance-alb)
Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку нагрузки как исходящего 
(TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). 
Не требует специальной поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.


# 5.  Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
/29 - Total Number of Hosts:	8 Number of Usable Hosts:	6
32 подсети
Network Address	Usable Host Range	Broadcast Address:
10.10.10.0	10.10.10.1 - 10.10.10.6	10.10.10.7
10.10.10.8	10.10.10.9 - 10.10.10.14	10.10.10.15
10.10.10.16	10.10.10.17 - 10.10.10.22	10.10.10.23
10.10.10.24	10.10.10.25 - 10.10.10.30	10.10.10.31
10.10.10.32	10.10.10.33 - 10.10.10.38	10.10.10.39
10.10.10.40	10.10.10.41 - 10.10.10.46	10.10.10.47


# 6.  Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Допустимо из любого частного диапазона, т.к. в другой организации может быть такая же адресация.
Подойдет маска /26 - 64 адреса.

# 7.  Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
Win - arp -a
очистить кеш arp -d удалить запись или netsh interface IP delete arpcache очистить кеш
Linux - arp -a, arp -an
arp -d удалить запись
ip -s -s neigh flush all очистить кеш
