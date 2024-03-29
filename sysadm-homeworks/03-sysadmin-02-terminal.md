 ### 1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа.
			type cd
			cd is a shell builtin
			Команда встроенная, т.к. именно в оболочке доджны быть доступны команды перемещения по файловой системе
			Допустим мы вошли в систему, но не настроены пути, в текущем каталоге нет к примеру даже ls.
			Мы должны иметь возможность перейти в /usr/bin или т.п. чтобы выполнить программу.

### 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?

			grep -c <some_string> <some_file>

### 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

		Процесс init или systemd родитель для всех. Зависит от системы инициализации.

### 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
	
		ls -lah 2 > /dev/pts/2

### 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

		awk '{print $1}' < list_file1.txt > filter_list.txt

### 6. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

		echo 'Hello' > /dev/tty1
		Необходимо выполнить login в этот tty

### 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

		bash 5>&1 создает новый дескриптор файла с номером 5 и 
		перенаправляет его на стандартный вывод (дескриптор 1). 
		при записи в дескриптор 5 данные будут выводиться на экран.

		echo netology > /proc/$$/fd/5, запишет строку "netology" в дескриптор файла 5, 
		который был ранее перенаправлен на стандартный вывод, т.е. fd/1. 
		В результате строка "netology" будет выведена на экран.

		/proc/$$/fd/5 представляет собой символическую ссылку на файловый дескриптор 5 процесса, 
		в моем примере это /proc/7186/fd/5 -> /dev/pts/1, который выполняет команду. 
		То есть команда echo netology > /proc/$$/fd/5 перенаправляет вывод команды echo на дескриптор файла 5 процесса, который выполняет эту команду, и затем эти данные выводятся на экран через стандартный вывод, 
		на который был перенаправлен дескриптор 5.

### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
	#### Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
	
		Да, можно использовать только стандартный поток ошибок (stderr) в качестве входного потока для конвейера (pipe) и при этом сохранить отображение стандартного вывода (stdout) на терминал (pty). Для этого можно использовать файловый дескриптор 2, который является дескриптором для стандартного потока ошибок.

		Например:
		ls -l /blahblah 2>&1 | grep "No such file or directory"
		Команда ls -l /blahblah будет выдавать сообщение об ошибке в стандартный поток ошибок, 
		который перенаправлен в стандартный вывод с помощью 2>&1. 
		Затем на стандартный вывод поток передается в команду grep, которая ищет строку "No such file or directory". 
		Результат выполнения этого конвейера будет выведен на терминал (pty), 
		поскольку stdout не был перенаправлен

### 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

		Команда выведет на экран переменные окружения в моем сеансе. Аналог команды env и printenv.

### 10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

		Файл /proc/<PID>/cmdline содержит аргументы командной строки, 
		с которыми был запущен процесс с указанным идентификатором PID. 
		Этот файл представляет собой текстовую строку, которая содержит все аргументы командной строки, 
		разделенные нулевым байтом. Файл /proc/<PID>/cmdline можно использовать для определения, 
		какие параметры были переданы процессу при его запуске.

		Файл /proc/<PID>/exe является символической ссылкой на исполняемый файл, 
		который был использован для запуска процесса с указанным идентификатором PID. 
		Этот файл можно использовать для определения, 
		какой именно исполняемый файл был использован для запуска процесса.

### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

		cat /proc/cpuinfo  | grep -o 'sse[0-9_]*' | sort -h | uniq
		sse
		sse2
		sse3
		sse4_1
		sse4_2
		
		Версия 4.2


### 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty.
#### Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
#### vagrant@netology1:~$ ssh localhost 'tty'
#### not a tty
#### Почитайте, почему так происходит, и как изменить поведение.

		Выполнение команды ssh localhost 'tty' в одном терминале с Vagrant, 
		удаленно выполненяет команду tty на локальной машине. 
		Когда команда tty выполняется на локальной машине через SSH, 
		она не находится в терминальной сессии и поэтому не имеет доступа к псевдо-терминалу (pty), 
		который используется для связи с терминалом.

		По умолчанию, при выполнении ssh, SSH-клиент не выделяет терминал на стороне сервера. 
		Это происходит потому, что SSH-клиент не знает, какой именно терминал использовать, 
		так как он не связан с конкретным терминалом на стороне клиента.

		Для того, чтобы изменить это поведение, можно использовать опцию -t при выполнении команды ssh. 
		Этот ключ указывает SSH-клиенту выделить терминал на стороне сервера.
		
		$ ssh -t localhost 'tty'
		vagrant@localhost's password:
		/dev/pts/1
		Connection to localhost closed.
	

### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
		
		Первым шагом устанвил утилиту, потом для примера перемещаем bash процесс из SSH сессии в screen
		1. во втором терминале ищем свою сессию, поможет who и ps aux | grep bash, находим номер pts
		2. screen
		3. sudo reptyr -s 0 <PID процесса>
		4. убедиться что все переместилось ps aux | grep bash 

### 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте? что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

		tee пишет  в файл и stdout одновременно. 

		echo string | sudo tee /root/new_file, процесс tee запускается с привилегиями root. 
		Перенаправление происходит в контексте tee,с привилегиями root, но не в контексте bash от пользователя. 
		sudo tee - имеет достаточные привилегии для записи в /root/new_file.

		sudo echo string > /root/new_fileпытается выполнить перенаправление вывода с правами root, но c контексте пользователя без прав на файл /root/new_file. То есть, при использовании >, перенаправление происходит в контексте bash процесса не-root пользователя и не имеет прав на запись в /root/new_file.