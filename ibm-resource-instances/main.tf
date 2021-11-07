data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

# COS instance
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

# COS bucket
resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name = var.cos.bucket_name
  resource_instance_id = ibm_resource_instance.cos.id
  region_location = var.cos.bucket_location
  storage_class = var.cos.bucket_storage_class
}

resource "ibm_cos_bucket_object" "ibm_logo" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  endpoint_type   = "public"
  content_file    = "${path.module}/ibm.png"
  key             = "ibm.png"
  etag            = filemd5("${path.module}/ibm.png")
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
}

resource "ibm_cis_dns_record" "cis_dns_record" {
  cis_id = ibm_cis.cis_instance.id
  domain_id = ibm_cis_domain.cis_domain.id
  name = var.web.hostname
  type = "A"
  content = var.web.address
  proxied = true
}

resource "ibm_cis_dns_record" "cis_image_record" {
  cis_id = ibm_cis.cis_instance.id
  domain_id = ibm_cis_domain.cis_domain.id
  name = "images.friday-you.cns-foo.com"
  type = "CNAME"
  content = "s3.us-south.cloud-object-storage.appdomain.cloud"
  proxied = true
}

resource "ibm_cis_page_rule" "images_page_rule" {
  cis_id = ibm_cis.cis_instance.id
  domain_id = ibm_cis_domain.cis_domain.id
  targets {
    target = "url"
    constraint {
      operator = "matches"
      value = "friday-you.cns-foo.com/friday-you-images/*"
    }
  }

  actions {
    id = "resolve_override"
    value = "images.friday-you.cns-foo.com"
  }

  actions {
    id = "host_header_override"
    value = "s3.us-south.cloud-object-storage.appdomain.cloud"
  }
}