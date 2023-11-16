# Опишем создание двух одинаковых ВМ с использованием count loop
resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = "standard-v1"

  resources {
    cores        = 2
    memory       = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  allow_stopping_for_update = true
}


