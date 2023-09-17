resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.image_name
}
resource "yandex_compute_instance" "platform" {
  name        = local.vm_resources.web.instance_name
  platform_id = "standard-v1"
  resources {
    cores         = local.vm_resources.web.resources.cores
    memory        = local.vm_resources.web.resources.memory
    core_fraction = local.vm_resources.web.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.vm_resources.web.metadata

}
resource "yandex_compute_instance" "platform-db" {
  name        = local.vm_resources.db.instance_name
  platform_id = "standard-v1"
  resources {
    cores         = local.vm_resources.db.resources.cores
    memory        = local.vm_resources.db.resources.memory
    core_fraction = local.vm_resources.db.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.vm_resources.db.metadata
}

