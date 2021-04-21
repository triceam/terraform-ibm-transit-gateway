
resource null_resource print_names {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
}

data "ibm_resource_group" "resource_group" {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

locals {
  name_prefix = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  name        = var.name != "" ? var.name : "${replace(local.name_prefix, "/[^a-zA-Z0-9_\\-\\.]/", "")}-tg-gateway"
}

resource "ibm_tg_gateway" "tg_gw_instance"{
  name           = local.name
  location       = var.region
  global         = true
  resource_group = data.ibm_resource_group.resource_group.id
}

resource "ibm_tg_connection" "ibm_tg_connection_isntance"{
  count = length(var.connections)

  gateway = ibm_tg_gateway.tg_gw_instance.id
  network_type = "vpc"
  name= "connection_instance${count.index}"
  network_id = var.connections[count.index]
}

