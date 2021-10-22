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

# CIS instance
resource "ibm_cis" "cis_instance" {
  name = var.cis.instance_name
  plan = var.cis.plan
  location = var.cis.location
  resource_group_id = data.ibm_resource_group.group.id
  tags = ["friday-you", "experimential", "jet"]

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cis_domain" "cis_domain" {
  cis_id = ibm_cis.cis_instance.id
  domain = "friday-you.cns-foo.com"

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cis_dns_record" "cis_dns_record" {
  cis_id = ibm_cis.cis_instance.id
  domain_id = ibm_cis_domain.cis_domain.id
  name = var.web.hostname
  type = "A"
  content = var.web.address
  proxied = true
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}