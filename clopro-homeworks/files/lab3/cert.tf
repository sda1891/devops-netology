resource "yandex_cm_certificate" "user-certificate" {
  name    = "lab-cert"

  self_managed {
    certificate = <<-EOT
-----BEGIN CERTIFICATE-----
****
-----END CERTIFICATE-----
                  EOT
    private_key = <<-EOT
-----BEGIN PRIVATE KEY-----
****
-----END PRIVATE KEY-----
                  EOT
  }
}

