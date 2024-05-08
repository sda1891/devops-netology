module "vm-nat" {
  source          = "git::https://github.com/sda1891/yandex_compute_instance.git"
  env_name        = "lab"
  network_id      = yandex_vpc_network.cloudnet.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.lab-public-subnet-a.id ]
  security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  instance_name   = "vm-nat"
  instance_count  = 1
  image_family    = "nat-instance-ubuntu"
  image_id        = "fd80mrhj8fl2oe87o4e1"
  public_ip       = true
  known_internal_ip = "192.168.0.254"

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

