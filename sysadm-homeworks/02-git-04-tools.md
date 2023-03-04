Задание
В клонированном репозитории:

## 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
$ git show aefea

Ответ 
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Update CHANGELOG.md

## 2. Какому тегу соответствует коммит 85024d3?
$ git show 85024

Ответ 

tag: v0.12.23

## 3. Сколько родителей у коммита b8d720? Напишите их хеши.

$ git show --pretty=format:' %P' b8d720

Ответ 

56cd7859e05c36c06b56d013b55a252d0bb7e158

9ea88f22fc6269854151c571162c5bcf958bee2b

## 4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

$ git log v0.12.23..v0.12.24 --oneline

33ff1c03bb (tag: v0.12.24) v0.12.24

b14b74c493 [Website] vmc provider links

3f235065b9 Update CHANGELOG.md

6ae64e247b registry: Fix panic when server is unreachable

5c619ca1ba website: Remove links to the getting started guide's old location

06275647e2 Update CHANGELOG.md

d5f9411f51 command: Fix bug when using terraform login on Windows

4b6d06cc5d Update CHANGELOG.md

dd01a35078 Update CHANGELOG.md

225466bc3e Cleanup after v0.12.23 release


## 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы).

 $ git log -S'func providerSource' --oneline # Находим упоминание
 
 $ git show 5af1e6234a # Смотрим содержимое
 
 $ git show 8c928e8358
 
 Ответ 
 
 Фнукция была добавлена в комите 8c928e83589d90a031f811fae52a81be7153e82f
 
## 6. Найдите все коммиты в которых была изменена функция globalPluginDirs.

git grep 'func globalPluginDirs'

git log -L :'func globalPluginDirs':plugins.go --oneline

Ответ

78b1220558 Remove config.go and update things using its aliases

52dbf94834 keep .terraform.d/plugins for discovery

41ab0aef7a Add missing OS_ARCH dir to global plugin paths

66ebff90cd move some more plugin search path logic to command

8364383c35 Push plugin discovery down into command package (Здесь функция была создана)

## 7. Кто автор функции synchronizedWriters?
$ git log -S'func synchronizedWriters(' --oneline

bdfea50cc8 remove unused

5ac311e2a9 main: synchronize writes to VT100-faker on Windows


$ git log -S'func synchronizedWriters(' --pretty=format:'%h - %an %ae'

bdfea50cc8 - James Bardin j.bardin@gmail.com

5ac311e2a9 - Martin Atkins mart@degeneration.co.uk

Ответ

bdfea50cc8 - удалили

5ac311e2a9 - создали

Автор Martin Atkins

