module "public-vm" {
  source          = "git::https://github.com/sda1891/yandex_compute_instance.git"
  env_name        = "lab"
  network_id      = yandex_vpc_network.cloudnet.id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ yandex_vpc_subnet.public.id ]
  instance_name   = "public"
  instance_count  = 1
  image_id        = var.image_id
  public_ip       = true

  metadata = {
      serial-port-enable = 1
      user-data = data.template_file.cloudinit.rendered
  }
}