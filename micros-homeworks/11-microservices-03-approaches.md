# Домашнее задание к занятию «Микросервисы: подходы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.


## Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- облачная система;
- система контроля версий Git;
- репозиторий на каждый сервис;
- запуск сборки по событию из системы контроля версий;
- запуск сборки по кнопке с указанием параметров;
- возможность привязать настройки к каждой сборке;
- возможность создания шаблонов для различных конфигураций сборок;
- возможность безопасного хранения секретных данных (пароли, ключи доступа);
- несколько конфигураций для сборки из одного репозитория;
- кастомные шаги при сборке;
- собственные докер-образы для сборки проектов;
- возможность развернуть агентов сборки на собственных серверах;
- возможность параллельного запуска нескольких сборок;
- возможность параллельного запуска тестов.

Обоснуйте свой выбор.

## Ответ

В предыдущих модулях я познакомился с GitLab, считаю полностью соответвует предъявленным требованиям. Лично у меня получилось успешно выполнить задания в модуле CI/CD именно на GitLab.
Все требования к системе можно вынести в таблицу:

| Требование                                                      | Описание в GitLab                                                                                         |
|-----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Облачная система| GitLab предоставляет облачную версию своего сервиса. Также возможно использовать "Managed Service for GitLab + Runner" в Яндекс облаке или аналог в VK Cloud. |
| Система контроля версий Git| GitLab построен на основе системы контроля версий Git и дает инстурментарий для управления репозиториями. |
| Репозиторий на каждый сервис| Поддерживается.|
| Запуск сборки по событию из системы контроля версий| Поддерживается.|
| Запуск сборки по кнопке с указанием параметров| Ручной запуск сборки поддерживается.|
| Возможность привязать настройки к каждой сборке| Поддерживается. |
| Возможность создания шаблонов для различных конфигураций сборок| Поддерживается.           |
| Возможность безопасного хранения секретных данных| Есть механизмы для безопасного хранения и использования секретных данных в процессе сборки. |
| Несколько конфигураций для сборки из одного репозитория| Поддерживается. |
| Кастомные шаги при сборке| Поддерживается. |
| Собственные Docker-образы для сборки проектов| Поддерживается.|
| Возможность развернуть агентов сборки на собственных серверах | Возможность есть. |
| Возможность параллельного запуска нескольких сборок| Поддерживается.       |
| Возможность параллельного запуска тестов| Поддерживается.|



## Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор логов в центральное хранилище со всех хостов, обслуживающих систему;
- минимальные требования к приложениям, сбор логов из stdout;
- гарантированная доставка логов до центрального хранилища;
- обеспечение поиска и фильтрации по записям логов;
- обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- возможность дать ссылку на сохранённый поиск по записям логов.

Обоснуйте свой выбор.

## Ответ

На мой взгляд для этой задачи оптимально взять следующие компоненты:

1. **Elastic Stack (ELK Stack)**: Набор открытых программных продуктов, включающий в себя Elasticsearch, Logstash и Kibana, предназначенных для сбора, анализа и визуализации данных.

2. **Filebeat**: Легковесный шиппер логов, который отправляет логи от сервисов и приложений в центральное хранилище (например, Logstash или Elasticsearch).

##### Принципы взаимодействия:

- Filebeat устанавливается на каждом хосте, обслуживающем систему, и настраивается для отправки логов в Logstash или Elasticsearch.
- Logstash, при необходимости, может использоваться для обогащения и фильтрации логов перед отправкой в Elasticsearch.
- Elasticsearch используется в качестве центрального хранилища для хранения и индексации логов.
- Kibana предоставляет веб-интерфейс для поиска, фильтрации и визуализации логов, а также для настройки дашбордов и сохраненных поисков.

##### Обоснование:

1. **Сбор логов**: Filebeat обеспечивает сбор логов из stdout с минимальными требованиями к приложениям, не требуя специальной настройки для каждого приложения.

2. **Гарантированная доставка логов**: Elastic Stack обеспечивает надежную доставку логов до центрального хранилища с помощью механизмов доставки и очередей.

3. **Поиск и фильтрация**: Elasticsearch предоставляет мощные инструменты для поиска и фильтрации логов с использованием Lucene-запросов и DSL запросов.

4. **Пользовательский интерфейс**: Kibana предоставляет удобный веб-интерфейс с возможностью предоставления доступа разработчикам для поиска по записям логов.

5. **Сохранённые поиски**: Kibana позволяет сохранять поисковые запросы и предоставлять ссылки на них, что упрощает доступ к часто используемым запросам.


## Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор метрик со всех хостов, обслуживающих систему;
- сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- сбор метрик, специфичных для каждого сервиса;
- пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- пользовательский интерфейс с возможностью настраивать различные панели для отслеживания состояния системы.

Обоснуйте свой выбор.

## Ответ

Для сбора и анализа состояния хостов и сервисов в микросервисной архитектуре можно использовать следующие программы:

1. Prometheus - это система мониторинга и алертинга, спроектированная для сбора и хранения временных рядов данных, таких как метрики состояния хостов и сервисов.

2. Node Exporter является агентом, который собирает метрики со всех хостов, обслуживающих систему, включая данные о CPU, памяти, диске и сети.

3. cAdvisor (Container Advisor) собирает метрики о потребляемых ресурсах для каждого контейнера Docker, включая CPU, память, дисковое пространство и сеть.

4. Exporter - сбор метрик, специфичных для каждого сервиса, можно использовать экспортеры, специализированные для конкретных технологий (например, MySQL Exporter, NGINX Exporter и т.д.), которые предоставляют метрики о состоянии соответствующих сервисов.

5. Grafana предоставляет пользовательский интерфейс для визуализации и анализа метрик, а также возможность создания кастомных панелей для отслеживания состояния системы.

##### Принципы взаимодействия:

- Node Exporter и cAdvisor устанавливаются на каждом хосте и контейнере Docker, чтобы собирать метрики о ресурсах и производительности.
- Prometheus используется для сбора и хранения метрик от Node Exporter, cAdvisor и экспортеров.
- Grafana настраивается для визуализации метрик, собранных Prometheus, и предоставляет пользовательский интерфейс для анализа и настройки панелей мониторинга.

##### Обоснование:

1. Prometheus обеспечивает гибкость в сборе и хранении различных типов метрик, а также возможность расширения за счет использования экспортеров.
  
2. Prometheus и Grafana являются открытыми проектами с активным сообществом разработчиков и поддержкой, что обеспечивает стабильность и развитие инструментов в долгосрочной перспективе.

3. Использование cAdvisor и экспортеров для мониторинга контейнеров обеспечивает возможность масштабирования и управления микросервисами в среде Docker.

4. Grafana предоставляет мощные инструменты для визуализации и анализа метрик, что позволяет быстро выявлять проблемы и отслеживать состояние системы.

В целом комбинация всех вышеуказанных компонентов даст довольно обширный и гибкий монтиринг микросервисной среды.

---