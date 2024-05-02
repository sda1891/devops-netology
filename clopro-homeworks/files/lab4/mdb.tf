resource "yandex_mdb_mysql_cluster" "lab-mysql-ha" {
  name                = "lab-mysql-ha"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.cloudnet.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ]
  deletion_protection = false

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-hdd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.lab-private-subnet-a.id
    assign_public_ip = false
  }

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.lab-private-subnet-b.id
    assign_public_ip = false
    backup_priority  = 10
  }

  host {
    zone             = "ru-central1-d"
    subnet_id        = yandex_vpc_subnet.lab-private-subnet-d.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.lab-mysql-ha.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "user1" {
  cluster_id = yandex_mdb_mysql_cluster.lab-mysql-ha.id
  name       = "user1"
  password   = "user1user1"
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

