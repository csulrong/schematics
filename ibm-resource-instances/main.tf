data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

resource "ibm_resource_instance" "cos" {
  name              = var.cos.instance_name
  service           = var.cos.service_name
  plan              = var.cos.plan
  location          = var.cos.location
  resource_group_id = data.ibm_resource_group.group.id
  tags              = ["friday-you", "experimental", "jet"]

  parameters = {
    "HMAC" = true
  }
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

