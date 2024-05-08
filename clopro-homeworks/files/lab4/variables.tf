variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "sa_id" {
  type   = string
  default = ""
} 

variable "cluster_id" {
  type   = string
  default = ""
}

variable "k8s_version" {
  type   = string
  default = ""
}

variable "public_zone_a_v4_cidr" {
  type   = string
  default = "192.168.0.0/24"
}

variable "public_zone_b_v4_cidr" {
  type   = string
  default = "192.168.1.0/24"
}

variable "public_zone_d_v4_cidr" {
  type   = string
  default = "192.168.3.0/24"
}
