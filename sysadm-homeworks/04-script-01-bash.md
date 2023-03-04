## Задание 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | просто вывел скленные строки a+b |
| `d`  | 1+2  | склеил строки из переменных $a и $b |
| `e`  | 3  | выполнил ариф. операция со значениями переменных $a и $b |

----

## Задание 2

На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:
```bash
while ((1==1))
do
	curl https://localhost:4757
	if (($? == 0))
	then
		break
	else
		date >> curl.log
	fi
done
```

---

## Задание 3

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
			#!/usr/bin/env bash

			ips=(192.168.0.1 173.194.222.113 87.250.250.242)
			count=5
			for ip in "${ips[@]}"; do
			for i in $(seq 1 $count); do
				nc -z $ip 80
				if [ $? -eq 0 ]; then
					echo "$(date +'%Y-%m-%d %H:%M:%S') - $ip:80 UP" >> log
				else
					echo "$(date +'%Y-%m-%d %H:%M:%S') - $ip:80 DOWN" >> log
				fi
				sleep 1

				done	
			done
```

---
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
			#!/usr/bin/env bash
			ips=(192.168.0.1 173.194.222.113 87.250.250.242)
			count=5
			while true; do
				for ip in "${ips[@]}"; do
					for i in $(seq 1 $count); do
						nc -z $ip 80
					if [ $? -eq 0 ]; then
						echo "$(date +'%Y-%m-%d %H:%M:%S') - $ip:80 UP" >> log
				else
					echo "$(date +'%Y-%m-%d %H:%M:%S') - $ip:80 DOWN" >> log
					echo "$ip" >> error
					exit 0
				fi
				sleep 1
				 done
			 done
			done
```

---

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
???
```

----

### Правила приема домашнего задания
В личном кабинете отправлена ссылка на .md файл в вашем репозитории.


### Критерии оценки

Зачет - выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки. 
 
Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.
Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.