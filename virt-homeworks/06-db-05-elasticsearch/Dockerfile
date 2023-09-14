FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget gpg ca-certificates
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg && \
echo "deb [trusted=yes signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://mirror.yandex.ru/mirrors/elastic/7/ stable main" | \
tee /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install -y elasticsearch
RUN mkdir -p /var/lib/elasticsearch && mkdir -p /tmp/snapshots
COPY elasticsearch.yml /etc/elasticsearch/
RUN chown -R elasticsearch:elasticsearch /etc/elasticsearch /usr/share/elasticsearch /var/lib/elasticsearch /tmp/snapshots
EXPOSE 9200
USER elasticsearch
CMD ["/usr/share/elasticsearch/bin/elasticsearch"]

