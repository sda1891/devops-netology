# Домашнее задание к занятию 14 «Средство визуализации Grafana»

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

  ![Datasource](./img/datasource-connect.PNG)


## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
```
avg(1 - avg(rate(node_cpu_seconds_total
		{prometheus=~"$prometheus",job=~"$job",mode="idle"}
[$interval])) by (instance)) * 100
```
- CPULA 1/5/15;
```
sum(node_load5{prometheus=~"$prometheus",job=~"$job"})

sum(node_load15{prometheus=~"$prometheus",job=~"$job"})

sum(node_load1{prometheus=~"$prometheus",job=~"$job"})
```
- количество свободной оперативной памяти;
```
sum(node_memory_MemFree_bytes{prometheus=~"$prometheus",job=~"$job"})  
```
- количество места на файловой системе.
```
100 - (node_filesystem_free_bytes
	{instance=~'$node', fstype=~"ext.*|xfs", mountpoint="/"} * 100 / 
node_filesystem_size_bytes
{instance=~'$node', fstype=~"ext.*|xfs", mountpoint="/"})
```

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

  ![dashboard1](./img/dashboard1.PNG)

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

	Возникла неожиданная проблема, Grafana не повзоляет создавать алерты при использовании шаблонов.
	Ошибка "Template variables are not supported in alert queries"
	Ресурсы в интернете предлагают костыльный вариант дублирования дашбордов с абсолютными значениями.
	Например  [**template-variables-are-not-supported-in-alert-queries-while-setting-up-alert**](https://community.grafana.com/t/template-variables-are-not-supported-in-alert-queries-while-setting-up-alert/2514)
    Для выполнения ДЗ я конечно сделал всё, но в проде с многими серверами сомнительное решение.

   ![dashboard1](./img/alerts.PNG)
  
   ![dashboard1](./img/dash-alerts.PNG)
 

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.
   
<details><summary>Dashboard JSON MODEL</summary>

```json
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": 3,
  "iteration": 1702495846498,
  "links": [],
  "panels": [
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 9,
        "x": 0,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 4,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "avg(1 - avg(rate(node_cpu_seconds_total{prometheus=~\"$prometheus\",job=~\"$job\",mode=\"idle\"}[$interval])) by (instance)) * 100",
          "interval": "10m",
          "legendFormat": "used%",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "$job: CPU Used %",
      "tooltip": {
        "shared": false,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:954",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:955",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "description": "",
      "fieldConfig": {
        "defaults": {
          "custom": {},
          "unit": "bytes"
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 9,
        "x": 9,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 6,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": true,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(node_memory_MemFree_bytes{prometheus=~\"$prometheus\",job=~\"$job\"})  ",
          "interval": "5m",
          "legendFormat": "Free",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "$job: Free Memory",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1208",
          "format": "bytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1209",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {},
          "custom": {},
          "thresholds": {
            "mode": "absolute",
            "steps": []
          },
          "unit": "short"
        },
        "overrides": []
      },
      "fill": 0,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 9,
        "x": 0,
        "y": 8
      },
      "hiddenSeries": false,
      "id": 2,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 3,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(node_load5{prometheus=~\"$prometheus\",job=~\"$job\"})",
          "interval": "10m",
          "legendFormat": "load5",
          "refId": "A"
        },
        {
          "expr": "sum(node_load15{prometheus=~\"$prometheus\",job=~\"$job\"})",
          "hide": false,
          "interval": "10m",
          "legendFormat": "load15",
          "refId": "B"
        },
        {
          "expr": "sum(node_load1{prometheus=~\"$prometheus\",job=~\"$job\"})",
          "hide": false,
          "interval": "10m",
          "legendFormat": "load1",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "$job：CPU Loadaverage",
      "tooltip": {
        "shared": true,
        "sort": 2,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:495",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:496",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 10,
        "w": 9,
        "x": 9,
        "y": 8
      },
      "hiddenSeries": false,
      "id": 8,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "100 - (node_filesystem_free_bytes{instance=~'$node', fstype=~\"ext.*|xfs\", mountpoint=\"/\"} * 100 / node_filesystem_size_bytes{instance=~'$node', fstype=~\"ext.*|xfs\", mountpoint=\"/\"})\r\n\r",
          "interval": "5m",
          "legendFormat": "{{mountpoint}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "$job: Free Disk Space",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "$$hashKey": "object:1389",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "$$hashKey": "object:1390",
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "schemaVersion": 27,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "allValue": null,
        "current": {
          "isNone": true,
          "selected": false,
          "text": "None",
          "value": ""
        },
        "datasource": null,
        "definition": "label_values(prometheus)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "prometheus",
        "multi": false,
        "name": "prometheus",
        "options": [],
        "query": {
          "query": "label_values(prometheus)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "nodeexporter",
          "value": "nodeexporter"
        },
        "datasource": null,
        "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\"}, job)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "JOB",
        "multi": false,
        "name": "job",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{prometheus=~\"$prometheus\"}, job)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "8a10400c54f5",
          "value": "8a10400c54f5"
        },
        "datasource": null,
        "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\"}, nodename)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "host",
        "multi": false,
        "name": "host",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\"}, nodename)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "192.168.1.45:9100",
          "value": "192.168.1.45:9100"
        },
        "datasource": null,
        "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",nodename=~\"$host\"},instance)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "instance",
        "multi": false,
        "name": "node",
        "options": [],
        "query": {
          "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",nodename=~\"$host\"},instance)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "auto": false,
        "auto_count": 30,
        "auto_min": "10s",
        "current": {
          "selected": false,
          "text": "30s",
          "value": "30s"
        },
        "description": null,
        "error": null,
        "hide": 0,
        "label": null,
        "name": "interval",
        "options": [
          {
            "selected": true,
            "text": "30s",
            "value": "30s"
          },
          {
            "selected": false,
            "text": "1m",
            "value": "1m"
          },
          {
            "selected": false,
            "text": "2m",
            "value": "2m"
          },
          {
            "selected": false,
            "text": "3m",
            "value": "3m"
          },
          {
            "selected": false,
            "text": "5m",
            "value": "5m"
          },
          {
            "selected": false,
            "text": "10m",
            "value": "10m"
          },
          {
            "selected": false,
            "text": "30m",
            "value": "30m"
          }
        ],
        "query": "30s,1m,2m,3m,5m,10m,30m",
        "refresh": 2,
        "skipUrlSync": false,
        "type": "interval"
      },
      {
        "allValue": null,
        "current": {
          "selected": false,
          "text": "8a10400c54f5",
          "value": "8a10400c54f5"
        },
        "datasource": null,
        "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",instance=~\"$node\"}, nodename)",
        "description": null,
        "error": null,
        "hide": 0,
        "includeAll": false,
        "label": "show_host",
        "multi": false,
        "name": "show_host",
        "options": [
          {
            "selected": true,
            "text": "8a10400c54f5",
            "value": "8a10400c54f5"
          }
        ],
        "query": {
          "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",instance=~\"$node\"}, nodename)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 0,
        "regex": "",
        "skipUrlSync": false,
        "sort": 5,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      }
    ]
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "15s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m"
    ]
  },
  "timezone": "browser",
  "title": "My Node Dashboard",
  "uid": "0qQIwfvIz",
  "version": 14
}
```
</details>

<details><summary>Dashboard Alerts JSON MODEL</summary>
```json
{
    "annotations": {
        "list": [
            {
                "builtIn": 1,
                "datasource": "-- Grafana --",
                "enable": true,
                "hide": true,
                "iconColor": "rgba(0, 211, 255, 1)",
                "name": "Annotations & Alerts",
                "type": "dashboard"
            }
        ]
    },
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "id": 4,
    "iteration": 1702495907848,
    "links": [],
    "panels": [
        {
            "alert": {
                "alertRuleTags": {},
                "conditions": [
                    {
                        "evaluator": {
                            "params": [
                                80
                            ],
                            "type": "gt"
                        },
                        "operator": {
                            "type": "and"
                        },
                        "query": {
                            "params": [
                                "A",
                                "5m",
                                "now"
                            ]
                        },
                        "reducer": {
                            "params": [],
                            "type": "avg"
                        },
                        "type": "query"
                    }
                ],
                "executionErrorState": "keep_state",
                "for": "5m",
                "frequency": "1m",
                "handler": 1,
                "name": "CPU Used % alert",
                "noDataState": "keep_state",
                "notifications": []
            },
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": null,
            "description": "",
            "fieldConfig": {
                "defaults": {
                    "custom": {}
                },
                "overrides": []
            },
            "fill": 1,
            "fillGradient": 0,
            "gridPos": {
                "h": 8,
                "w": 9,
                "x": 0,
                "y": 0
            },
            "hiddenSeries": false,
            "id": 4,
            "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
            },
            "lines": true,
            "linewidth": 1,
            "nullPointMode": "null",
            "options": {
                "alertThreshold": true
            },
            "percentage": false,
            "pluginVersion": "7.4.0",
            "pointradius": 2,
            "points": false,
            "renderer": "flot",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
                {
                    "expr": "avg(irate(node_cpu_seconds_total{job=\"nodeexporter\", mode=\"idle\"}[5m])) by (instance) * 100\r\n\r\n\r\n\r",
                    "interval": "10m",
                    "legendFormat": "used%",
                    "refId": "A"
                }
            ],
            "thresholds": [
                {
                    "colorMode": "critical",
                    "fill": true,
                    "line": true,
                    "op": "gt",
                    "value": 80,
                    "visible": true
                }
            ],
            "timeFrom": null,
            "timeRegions": [],
            "timeShift": null,
            "title": "$job: CPU Used %",
            "tooltip": {
                "shared": false,
                "sort": 0,
                "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
            },
            "yaxes": [
                {
                    "$$hashKey": "object:954",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                },
                {
                    "$$hashKey": "object:955",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                }
            ],
            "yaxis": {
                "align": false,
                "alignLevel": null
            }
        },
        {
            "alert": {
                "alertRuleTags": {},
                "conditions": [
                    {
                        "evaluator": {
                            "params": [
                                1
                            ],
                            "type": "lt"
                        },
                        "operator": {
                            "type": "and"
                        },
                        "query": {
                            "params": [
                                "A",
                                "5m",
                                "now"
                            ]
                        },
                        "reducer": {
                            "params": [],
                            "type": "sum"
                        },
                        "type": "query"
                    }
                ],
                "executionErrorState": "keep_state",
                "for": "5m",
                "frequency": "1m",
                "handler": 1,
                "name": "Free Memory alert",
                "noDataState": "keep_state",
                "notifications": []
            },
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": null,
            "description": "",
            "fieldConfig": {
                "defaults": {
                    "custom": {},
                    "unit": "bytes"
                },
                "overrides": []
            },
            "fill": 1,
            "fillGradient": 0,
            "gridPos": {
                "h": 8,
                "w": 9,
                "x": 9,
                "y": 0
            },
            "hiddenSeries": false,
            "id": 6,
            "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": true,
                "values": true
            },
            "lines": true,
            "linewidth": 1,
            "nullPointMode": "null",
            "options": {
                "alertThreshold": true
            },
            "percentage": false,
            "pluginVersion": "7.4.0",
            "pointradius": 2,
            "points": false,
            "renderer": "flot",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
                {
                    "expr": "sum(node_memory_MemFree_bytes{job=~\"nodeexporter\"})",
                    "interval": "5m",
                    "legendFormat": "Free",
                    "refId": "A"
                }
            ],
            "thresholds": [
                {
                    "colorMode": "critical",
                    "fill": true,
                    "line": true,
                    "op": "lt",
                    "value": 1,
                    "visible": true
                }
            ],
            "timeFrom": null,
            "timeRegions": [],
            "timeShift": null,
            "title": "$job: Free Memory",
            "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
            },
            "yaxes": [
                {
                    "$$hashKey": "object:1208",
                    "format": "bytes",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                },
                {
                    "$$hashKey": "object:1209",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                }
            ],
            "yaxis": {
                "align": false,
                "alignLevel": null
            }
        },
        {
            "alert": {
                "alertRuleTags": {},
                "conditions": [
                    {
                        "evaluator": {
                            "params": [
                                80
                            ],
                            "type": "gt"
                        },
                        "operator": {
                            "type": "and"
                        },
                        "query": {
                            "params": [
                                "A",
                                "5m",
                                "now"
                            ]
                        },
                        "reducer": {
                            "params": [],
                            "type": "max"
                        },
                        "type": "query"
                    }
                ],
                "executionErrorState": "keep_state",
                "for": "5m",
                "frequency": "1m",
                "handler": 1,
                "name": "CPU Loadaverage alert",
                "noDataState": "keep_state",
                "notifications": []
            },
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": null,
            "description": "",
            "fieldConfig": {
                "defaults": {
                    "color": {},
                    "custom": {},
                    "thresholds": {
                        "mode": "absolute",
                        "steps": []
                    },
                    "unit": "short"
                },
                "overrides": []
            },
            "fill": 0,
            "fillGradient": 0,
            "gridPos": {
                "h": 10,
                "w": 9,
                "x": 0,
                "y": 8
            },
            "hiddenSeries": false,
            "id": 2,
            "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
            },
            "lines": true,
            "linewidth": 2,
            "nullPointMode": "null",
            "options": {
                "alertThreshold": true
            },
            "percentage": false,
            "pluginVersion": "7.4.0",
            "pointradius": 2,
            "points": false,
            "renderer": "flot",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
                {
                    "expr": "sum(node_load5{job=\"nodeexporter\"})",
                    "interval": "10m",
                    "legendFormat": "load5",
                    "refId": "A"
                },
                {
                    "expr": "sum(node_load15{job=\"nodeexporter\"})",
                    "hide": false,
                    "interval": "10m",
                    "legendFormat": "load15",
                    "refId": "B"
                },
                {
                    "expr": "sum(node_load1{job=\"nodeexporter\"})",
                    "hide": false,
                    "interval": "10m",
                    "legendFormat": "load1",
                    "refId": "C"
                }
            ],
            "thresholds": [
                {
                    "colorMode": "critical",
                    "fill": true,
                    "line": true,
                    "op": "gt",
                    "value": 80,
                    "visible": true
                }
            ],
            "timeFrom": null,
            "timeRegions": [],
            "timeShift": null,
            "title": "CPU Loadaverage",
            "tooltip": {
                "shared": true,
                "sort": 2,
                "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
            },
            "yaxes": [
                {
                    "$$hashKey": "object:495",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                },
                {
                    "$$hashKey": "object:496",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                }
            ],
            "yaxis": {
                "align": false,
                "alignLevel": null
            }
        },
        {
            "alert": {
                "alertRuleTags": {},
                "conditions": [
                    {
                        "evaluator": {
                            "params": [
                                10
                            ],
                            "type": "lt"
                        },
                        "operator": {
                            "type": "and"
                        },
                        "query": {
                            "params": [
                                "A",
                                "5m",
                                "now"
                            ]
                        },
                        "reducer": {
                            "params": [],
                            "type": "sum"
                        },
                        "type": "query"
                    }
                ],
                "executionErrorState": "keep_state",
                "for": "5m",
                "frequency": "1m",
                "handler": 1,
                "name": "Free Disk Space alert",
                "noDataState": "keep_state",
                "notifications": []
            },
            "aliasColors": {},
            "bars": false,
            "dashLength": 10,
            "dashes": false,
            "datasource": null,
            "fieldConfig": {
                "defaults": {
                    "custom": {}
                },
                "overrides": []
            },
            "fill": 1,
            "fillGradient": 0,
            "gridPos": {
                "h": 10,
                "w": 9,
                "x": 9,
                "y": 8
            },
            "hiddenSeries": false,
            "id": 8,
            "legend": {
                "avg": false,
                "current": false,
                "max": false,
                "min": false,
                "show": true,
                "total": false,
                "values": false
            },
            "lines": true,
            "linewidth": 1,
            "nullPointMode": "null",
            "options": {
                "alertThreshold": true
            },
            "percentage": false,
            "pluginVersion": "7.4.0",
            "pointradius": 2,
            "points": false,
            "renderer": "flot",
            "seriesOverrides": [],
            "spaceLength": 10,
            "stack": false,
            "steppedLine": false,
            "targets": [
                {
                    "expr": "100 - (node_filesystem_free_bytes{instance=\"192.168.1.45:9100\", fstype=~\"ext.*|xfs\", mountpoint=\"/\"} * 100 / node_filesystem_size_bytes{instance=\"192.168.1.45:9100\", fstype=~\"ext.*|xfs\", mountpoint=\"/\"})\r",
                    "interval": "5m",
                    "legendFormat": "{{mountpoint}}",
                    "refId": "A"
                }
            ],
            "thresholds": [
                {
                    "colorMode": "critical",
                    "fill": true,
                    "line": true,
                    "op": "lt",
                    "value": 10,
                    "visible": true
                }
            ],
            "timeFrom": null,
            "timeRegions": [],
            "timeShift": null,
            "title": "$job: Free Disk Space",
            "tooltip": {
                "shared": true,
                "sort": 0,
                "value_type": "individual"
            },
            "type": "graph",
            "xaxis": {
                "buckets": null,
                "mode": "time",
                "name": null,
                "show": true,
                "values": []
            },
            "yaxes": [
                {
                    "$$hashKey": "object:1389",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                },
                {
                    "$$hashKey": "object:1390",
                    "format": "short",
                    "label": null,
                    "logBase": 1,
                    "max": null,
                    "min": null,
                    "show": true
                }
            ],
            "yaxis": {
                "align": false,
                "alignLevel": null
            }
        }
    ],
    "refresh": false,
    "schemaVersion": 27,
    "style": "dark",
    "tags": [],
    "templating": {
        "list": [
            {
                "allValue": null,
                "current": {
                    "isNone": true,
                    "selected": false,
                    "text": "None",
                    "value": ""
                },
                "datasource": null,
                "definition": "label_values(prometheus)",
                "description": null,
                "error": null,
                "hide": 0,
                "includeAll": false,
                "label": "prometheus",
                "multi": false,
                "name": "prometheus",
                "options": [],
                "query": {
                    "query": "label_values(prometheus)",
                    "refId": "StandardVariableQuery"
                },
                "refresh": 1,
                "regex": "",
                "skipUrlSync": false,
                "sort": 5,
                "tagValuesQuery": "",
                "tags": [],
                "tagsQuery": "",
                "type": "query",
                "useTags": false
            },
            {
                "allValue": null,
                "current": {
                    "selected": false,
                    "text": "nodeexporter",
                    "value": "nodeexporter"
                },
                "datasource": null,
                "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\"}, job)",
                "description": null,
                "error": null,
                "hide": 0,
                "includeAll": false,
                "label": "JOB",
                "multi": false,
                "name": "job",
                "options": [],
                "query": {
                    "query": "label_values(node_uname_info{prometheus=~\"$prometheus\"}, job)",
                    "refId": "StandardVariableQuery"
                },
                "refresh": 1,
                "regex": "",
                "skipUrlSync": false,
                "sort": 5,
                "tagValuesQuery": "",
                "tags": [],
                "tagsQuery": "",
                "type": "query",
                "useTags": false
            },
            {
                "allValue": null,
                "current": {
                    "selected": false,
                    "text": "8a10400c54f5",
                    "value": "8a10400c54f5"
                },
                "datasource": null,
                "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\"}, nodename)",
                "description": null,
                "error": null,
                "hide": 0,
                "includeAll": false,
                "label": "host",
                "multi": false,
                "name": "host",
                "options": [],
                "query": {
                    "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\"}, nodename)",
                    "refId": "StandardVariableQuery"
                },
                "refresh": 1,
                "regex": "",
                "skipUrlSync": false,
                "sort": 5,
                "tagValuesQuery": "",
                "tags": [],
                "tagsQuery": "",
                "type": "query",
                "useTags": false
            },
            {
                "allValue": null,
                "current": {
                    "selected": false,
                    "text": "192.168.1.45:9100",
                    "value": "192.168.1.45:9100"
                },
                "datasource": null,
                "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",nodename=~\"$host\"},instance)",
                "description": null,
                "error": null,
                "hide": 0,
                "includeAll": false,
                "label": "instance",
                "multi": false,
                "name": "node",
                "options": [],
                "query": {
                    "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",nodename=~\"$host\"},instance)",
                    "refId": "StandardVariableQuery"
                },
                "refresh": 1,
                "regex": "",
                "skipUrlSync": false,
                "sort": 5,
                "tagValuesQuery": "",
                "tags": [],
                "tagsQuery": "",
                "type": "query",
                "useTags": false
            },
            {
                "auto": false,
                "auto_count": 30,
                "auto_min": "10s",
                "current": {
                    "selected": false,
                    "text": "30s",
                    "value": "30s"
                },
                "description": null,
                "error": null,
                "hide": 0,
                "label": null,
                "name": "interval",
                "options": [
                    {
                        "selected": true,
                        "text": "30s",
                        "value": "30s"
                    },
                    {
                        "selected": false,
                        "text": "1m",
                        "value": "1m"
                    },
                    {
                        "selected": false,
                        "text": "2m",
                        "value": "2m"
                    },
                    {
                        "selected": false,
                        "text": "3m",
                        "value": "3m"
                    },
                    {
                        "selected": false,
                        "text": "5m",
                        "value": "5m"
                    },
                    {
                        "selected": false,
                        "text": "10m",
                        "value": "10m"
                    },
                    {
                        "selected": false,
                        "text": "30m",
                        "value": "30m"
                    }
                ],
                "query": "30s,1m,2m,3m,5m,10m,30m",
                "refresh": 2,
                "skipUrlSync": false,
                "type": "interval"
            },
            {
                "allValue": null,
                "current": {
                    "selected": false,
                    "text": "8a10400c54f5",
                    "value": "8a10400c54f5"
                },
                "datasource": null,
                "definition": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",instance=~\"$node\"}, nodename)",
                "description": null,
                "error": null,
                "hide": 0,
                "includeAll": false,
                "label": "show_host",
                "multi": false,
                "name": "show_host",
                "options": [
                    {
                        "selected": true,
                        "text": "8a10400c54f5",
                        "value": "8a10400c54f5"
                    }
                ],
                "query": {
                    "query": "label_values(node_uname_info{prometheus=~\"$prometheus\",job=~\"$job\",instance=~\"$node\"}, nodename)",
                    "refId": "StandardVariableQuery"
                },
                "refresh": 0,
                "regex": "",
                "skipUrlSync": false,
                "sort": 5,
                "tagValuesQuery": "",
                "tags": [],
                "tagsQuery": "",
                "type": "query",
                "useTags": false
            }
        ]
    },
    "time": {
        "from": "now-1h",
        "to": "now"
    },
    "timepicker": {
        "refresh_intervals": [
            "15s",
            "30s",
            "1m",
            "5m",
            "15m",
            "30m"
        ]
    },
    "timezone": "browser",
    "title": "My Node Dashboard Alert",
    "uid": "0qQIwfvIx",
    "version": 10
}
```
</details>

---
