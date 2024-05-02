# Локальные переменные
locals {
  network_name     = "cloudnet"
  sg_nat_name      = "nat-instance-sg"
  route_table_name = "nat-instance-route"
}

# Создание облачной сети

resource "yandex_vpc_network" "cloudnet" {
  name = local.network_name
}

# Создание подсетей

resource "yandex_vpc_subnet" "lab-public-subnet-a" {
  name           = "lab-public-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks = [var.public_zone_a_v4_cidr]
}

resource "yandex_vpc_subnet" "lab-public-subnet-b" {
  name           = "lab-public-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks = [var.public_zone_b_v4_cidr]
}

resource "yandex_vpc_subnet" "lab-public-subnet-d" {
  name           = "lab-public-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks = [var.public_zone_d_v4_cidr]
}

resource "yandex_vpc_subnet" "lab-private-subnet-a" {
  name             = "lab-private-subnet-a"
  zone             = "ru-central1-a"
  network_id       = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks   = ["192.168.10.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "lab-private-subnet-b" {
  name             = "lab-private-subnet-b"
  zone             = "ru-central1-b"
  network_id       = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks   = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "lab-private-subnet-d" {
  name             = "lab-private-subnet-d"
  zone             = "ru-central1-d"
  network_id       = yandex_vpc_network.cloudnet.id
  v4_cidr_blocks   = ["192.168.30.0/24"]
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

# Создание групп безпасности

resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = yandex_vpc_network.cloudnet.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "MySQL"
    port           = 3306
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow icmp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

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
    protocol       = "ICMP"
    description    = "allow icmp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

# Создание групп безопасности для MK8S  

resource "yandex_vpc_security_group" "k8s-main-sg" {
  description = "Security group ensure the basic performance of the cluster. Apply it to the cluster and node groups."
  name        = "k8s-main-sg"
  network_id  = yandex_vpc_network.cloudnet.id

  ingress {
    description    = "The rule allows availability checks from the load balancer's range of addresses. It is required for the operation of a fault-tolerant cluster and load balancer services."
    protocol       = "TCP"
#    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24", "158.160.156.0/24"] # The load balancer's address range
    predefined_target = "loadbalancer_healthchecks" # The load balancer's address range
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    description       = "The rule allows the master-node and node-node interaction within the security group"
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    description    = "The rule allows the pod-pod and service-service interaction. Specify the subnets of your cluster and services."
    protocol       = "ANY"
    v4_cidr_blocks = [var.public_zone_a_v4_cidr]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    description    = "The rule allows receipt of debugging ICMP packets from internal subnets"
    protocol       = "ICMP"
    v4_cidr_blocks = [var.public_zone_a_v4_cidr]
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 6443 port from specified network"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  ingress {
    description    = "The rule allows connection to Kubernetes API on 443 port from specified network"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    description    = "The rule allows incoming traffic from the internet to the NodePort port range. Add ports or change existing ones to the required ports."
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  egress {
    description    = "The rule allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Object Storage, Docker Hub, and more."
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

