# Создаем сервис аккаунт

resource "yandex_iam_service_account" "k8s-sa" {
  description = "Service account for Kubernetes cluster"
  name        = var.sa_id
}

# Назначем роли сервисному аккануту

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}


# Assign "editor" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "admin" {
  folder_id = var.folder_id
  role      = "admin"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}

# Assign "container-registry.images.puller" role to Kubernetes service account
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}

# Создаем кластер

resource "yandex_kubernetes_cluster" "k8s-cluster" {
  description = "Managed Service for Kubernetes cluster"
  name        = var.cluster_id
  network_id  = yandex_vpc_network.cloudnet.id

  master {
    version = var.k8s_version
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.lab-public-subnet-a.zone
        subnet_id = yandex_vpc_subnet.lab-public-subnet-a.id
      }

      location {
        zone      = yandex_vpc_subnet.lab-public-subnet-b.zone
        subnet_id = yandex_vpc_subnet.lab-public-subnet-b.id
      }

      location {
        zone      = yandex_vpc_subnet.lab-public-subnet-d.zone
        subnet_id = yandex_vpc_subnet.lab-public-subnet-d.id
      }
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
  }
  service_account_id      = yandex_iam_service_account.k8s-sa.id # Cluster service account ID
  node_service_account_id = yandex_iam_service_account.k8s-sa.id # Node group service account ID
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.admin,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.lab-key-a.id
  }
}

