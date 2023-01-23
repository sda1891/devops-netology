1.  # telnet ya.ru 80
Trying 87.250.250.242...
Connected to ya.ru.
Escape character is '^]'.
GET /questions HTTP/1.0

HTTP/1.1 406 Not acceptable
Content-Length: 0
NEL: {"report_to": "network-errors", "max_age": 100, "success_fraction": 0.001, "failure_fraction": 0.1}
Report-To: { "group": "network-errors", "max_age": 100, "endpoints": [{"url": "https://dr.yandex.net/nel", "priority": 1}, {"url": "https://dr2.yandex.net/nel", "priority": 2}]}
X-Content-Type-Options: nosniff
X-Yandex-Req-Id: 1674496126370311-16419392782617364840-sas0-8326-00a-sas-l7-balancer-8080-BAL

Сервер не принял запрос клиента, возможно такой метод не поддерживается.

2.  Request URL: https://ya.ru/
Request Method: GET
Status Code: 200 
Remote Address: 87.250.250.242:443
Referrer Policy: strict-origin-when-cross-origin
![image](https://user-images.githubusercontent.com/11519688/214113307-2bb88da7-624b-49cd-9afb-639f048aa236.png)

3. 77.91.69.152
4. # whois -h whois.radb.net 77.91.69.152
route:          77.91.69.0/24
origin:         AS206446
descr:          Webhost LLC
notify:         abuse@webhost1.ru
mnt-by:         MNT-FOTONTELECOM-CJSC
mnt-by:         MNT-FOTONTELECOM
 
5.  # traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  77.91.69.1 [AS206446]  1.130 ms  1.077 ms  1.027 ms
 2  10.188.191.102 [*]  0.965 ms  0.905 ms  0.872 ms
 3  84.110.57.153 [AS8551]  0.800 ms  0.746 ms  0.698 ms
 4  * * *
 5  10.90.99.9 [*]  1083.395 ms  1083.322 ms  1083.266 ms
 6  72.14.211.60 [AS15169]  38.931 ms  39.023 ms  38.992 ms
 7  * * *
 8  8.8.8.8 [AS15169/AS263411]  78.307 ms  78.294 ms  77.862 ms

6. ![image](https://user-images.githubusercontent.com/11519688/214114412-cc7d21c0-3293-4c0e-adf3-19c5c9235bdf.png)

7.  # dig  +short @8.8.8.8 dns.google
8.8.4.4
8.8.8.8
А записи
;; ANSWER SECTION:
dns.google.             194     IN      A       8.8.4.4
dns.google.             194     IN      A       8.8.8.8

8.  [root@grootpoint ~]# dig +short  @8.8.8.8 -x 8.8.8.8
dns.google.

[root@grootpoint ~]# dig +short  @8.8.8.8 -x 8.8.4.4
dns.google.




