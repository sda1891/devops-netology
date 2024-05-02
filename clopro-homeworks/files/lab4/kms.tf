resource "yandex_kms_symmetric_key" "lab-key-a" {
  name              = "lab-key-a"
  description       = "LAB 15.3 key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}
