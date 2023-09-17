variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))

  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5 
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "org" {
  default = "netology"
}

variable "org-unit" {
  default = "develop"
}

variable "comp_inst_name" {
  default = "platform"
}

variable "comp_inst_type" {
  type    = list(string)
  default = ["db", "web"]
}
