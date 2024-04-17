terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

locals {
  network_name     = "cloudnet"
  subnet_name1     = "public"
  subnet_name2     = "private"
  sg_nat_name      = "nat-instance-sg"
  route_table_name = "nat-instance-route"
}

# Создание облачной сети

resource "yandex_vpc_network" "cloudnet" {
  name = local.network_name
}

# Создание подсетей

resource "yandex_vpc_subnet" "public" {
  name           = local.subnet_name1
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = local.subnet_name2
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

# Создание таблицы маршрутизации и статического маршрута

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.cloudnet.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = module.vm-nat.internal_ip_address[0]
  }
}

# Создание группы безопасности

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.cloudnet.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow icmp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

# Создание ВМ

module "vm" {
  source          = "git::https://github.com/sda1891/yandex_compute_instance.git"
  env_name        = "lab"
  network_id      = yandex_vpc_network.cloudnet.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.private.id ]
  security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  instance_name   = "web"
  instance_count  = 1
  image_id        = var.image_id
  public_ip       = false

  metadata = {
      serial-port-enable = 1
      user-data = data.template_file.cloudinit.rendered
  }
}

# Создание ВМ NAT

module "vm-nat" {
  source          = "git::https://github.com/sda1891/yandex_compute_instance.git"
  env_name        = "lab"
  network_id      = yandex_vpc_network.cloudnet.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.public.id ]
  security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  instance_name   = "vm-nat"
  instance_count  = 1
  image_family    = "nat-instance-ubuntu"
  image_id        = "fd80mrhj8fl2oe87o4e1"
  public_ip       = true
  known_internal_ip = "192.168.10.254"

# known_internal_ip = var.known_internal_ip
# image_id          = var.image_id

  metadata = {
      serial-port-enable = 1
      user-data = data.template_file.cloudinit.rendered
  }
}

# Передача cloud-config в ВМ
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")

}