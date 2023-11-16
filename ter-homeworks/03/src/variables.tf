# Объявление переменных
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

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "public_key" {
  type    = string
  default = <<EOT
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwvof+MT42FEMJ3hjXheapLcbOFVdtTSENPTvWzy/tGTVAiF4ozofS0NAz+UAONZhqPPB+HPiGQtP1qqq1Ga0Co30cX5RFkxZyqa8HX0RsLQwTfcE7joA2gupy62owMMiCRpDpcPbsNaBdadGYm3Z6r6JBwO+HoOJNhAXj6YAl50DmjYBTlKguiAAGk8M3iXAJjS1ioHKIxIzBwK1LoX9c9/pQAnBDJgd2K60fRsm59COVIJfiuACyW4JCiY/+n1uhlzFDqFkh+5GEa89UqETWVhDngj8AaXQBpVuh8KD3PH7nSKijjUczPcvzwiwrg+SPLvTI3YmZJTqMlyTuNpmC0mXaO2e35LFpNt8sYezW0hyc9/jrGqF
EOT
}

