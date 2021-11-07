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

resource "ibm_cos_bucket_object" "carbon_components_css" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/carbon-components.css"
  key             = "carbon-components.css"
  etag            = filemd5("${path.module}/files/carbon-components.css")
}

resource "ibm_cos_bucket_object" "warning_page_styles_css" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_page_styles.css"
  key             = "warning_page_styles.css"
  etag            = filemd5("${path.module}/files/warning_page_styles.css")
}

resource "ibm_cos_bucket_object" "warning_1000_errors" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_1000_errors.html"
  key             = "warning_1000_errors.html"
  etag            = filemd5("${path.module}/files/warning_1000_errors.html")
}

resource "ibm_cos_bucket_object" "warning_500_errors" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_500_errors.html"
  key             = "warning_500_errors.html"
  etag            = filemd5("${path.module}/files/warning_500_errors.html")
}

resource "ibm_cos_bucket_object" "warning_always_online" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_always_online.html"
  key             = "warning_always_online.html"
  etag            = filemd5("${path.module}/files/warning_always_online.html")
}

resource "ibm_cos_bucket_object" "warning_basic_challenge" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_basic_challenge.html"
  key             = "warning_basic_challenge.html"
  etag            = filemd5("${path.module}/files/warning_basic_challenge.html")
}

resource "ibm_cos_bucket_object" "warning_country_challenge" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_country_challenge.html"
  key             = "warning_country_challenge.html"
  etag            = filemd5("${path.module}/files/warning_country_challenge.html")
}

resource "ibm_cos_bucket_object" "warning_ip_block" {
  bucket_crn      = ibm_cos_bucket.cos_bucket.crn
  bucket_location = ibm_cos_bucket.cos_bucket.region_location
  content_file    = "${path.module}/files/warning_ip_block.html"
  key             = "warning_ip_block.html"
  etag            = filemd5("${path.module}/files/warning_ip_block.html")
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

resource "ibm_cis_custom_page" "basic_challenge" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "basic_challenge"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_basic_challenge.html"
}

resource "ibm_cis_custom_page" "country_challenge" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "country_challenge"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_country_challenge.html"
}

resource "ibm_cis_custom_page" "ip_block" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "ip_block"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_ip_block.html"
}

resource "ibm_cis_custom_page" "always_online" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "always_online"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_always_online.html"
}

resource "ibm_cis_custom_page" "warining_1000_errors" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "1000_errors"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_1000_errors.html"
}

resource "ibm_cis_custom_page" "warining_500_errors" {
    cis_id    = ibm_cis.cis_instance.id
    domain_id = ibm_cis_domain.cis_domain.id
    page_id   = "500_errors"
    url       = "https://s3.us-south.cloud-object-storage.appdomain.cloud/cis-custom-pages/warning_500_errors.html"
}