locals {

  shared_metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

  vm_resources = {
    web = {
      instance_name = "${var.org}-${var.org-unit}-${var.comp_inst_name}-${element(var.comp_inst_type, 1)}"
      resources      = var.vms_resources["web"]
      metadata       = local.shared_metadata
    }
    db = {
      instance_name = "${var.org}-${var.org-unit}-${var.comp_inst_name}-${element(var.comp_inst_type, 0)}"
      resources      = var.vms_resources["db"]
      metadata       = local.shared_metadata
    }
  }
}


