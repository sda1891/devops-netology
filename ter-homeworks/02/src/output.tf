output "instance_ips" {
  value = {
    web = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    db  = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
  }
}

