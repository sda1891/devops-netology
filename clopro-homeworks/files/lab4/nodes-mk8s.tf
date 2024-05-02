resource "yandex_kubernetes_node_group" "k8s-node-group-a" {
  description = "Node group for the Managed Service for Kubernetes cluster"
  name        = "k8s-node-group-a"
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  version     = var.k8s_version

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.lab-public-subnet-a.zone
    }
  }

  instance_template {
    platform_id = "standard-v2" # Intel Cascade Lake

    scheduling_policy {
      preemptible =  true
    }

    metadata         = {
      enable-oslogin = "true"
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.lab-public-subnet-a.id]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
    }

    resources {
      memory = 4 # RAM quantity in GB
      cores  = 4 # Number of CPU cores
      core_fraction = 5
    }

    boot_disk {
      type = "network-hdd"
      size = 64 # Disk size in GB
    }
  }
}

resource "yandex_kubernetes_node_group" "k8s-node-group-b" {
  description = "Node group for the Managed Service for Kubernetes cluster"
  name        = "k8s-node-group-b"
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  version     = var.k8s_version

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.lab-public-subnet-b.zone
    }
  }

  instance_template {
    platform_id = "standard-v2" # Intel Cascade Lake

    scheduling_policy {
      preemptible =  true
    }

    metadata         = {
      enable-oslogin = "true"
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.lab-public-subnet-b.id]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
    }

    resources {
      memory = 4 # RAM quantity in GB
      cores  = 4 # Number of CPU cores
      core_fraction = 5
    }

    boot_disk {
      type = "network-hdd"
      size = 64 # Disk size in GB
    }
  }
}

resource "yandex_kubernetes_node_group" "k8s-node-group-d" {
  description = "Node group for the Managed Service for Kubernetes cluster"
  name        = "k8s-node-group-d"
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  version     = var.k8s_version

  scale_policy {
    auto_scale {
      initial = 1
      max     = 2
      min     = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.lab-public-subnet-d.zone
    }
  }

  instance_template {
    platform_id = "standard-v2" # Intel Cascade Lake

    scheduling_policy {
      preemptible =  true
    }

    metadata         = {
      enable-oslogin = "true"
    }

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.lab-public-subnet-d.id]
      security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
    }

    resources {
      memory = 4 # RAM quantity in GB
      cores  = 4 # Number of CPU cores
      core_fraction = 5
    }

    boot_disk {
      type = "network-hdd"
      size = 64 # Disk size in GB
    }
  }
}

