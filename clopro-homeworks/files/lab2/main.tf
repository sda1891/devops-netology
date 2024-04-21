locals {
  network_name     = "cloudnet"
  subnet_name1     = "public"
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

# Создание группы ВМ
resource "yandex_compute_instance_group" "group1" {
  name                = "lab-ig"
  folder_id           = var.folder_id
  service_account_id  = var.sa_id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        # images_id из условия задания	  
        image_id = "fd827b91d99psvq5fjit"
        size     = 4
      }
    }
    network_interface {
      network_id = yandex_vpc_network.cloudnet.id
      subnet_ids = [ yandex_vpc_subnet.public.id ]
      nat        = true
    }
    metadata = {
      serial-port-enable = 1
      user-data = data.template_file.cloudinit.rendered
      #ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = ["ru-central1-a"]
  }
  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}

# Передача cloud-config в ВМ
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
}
