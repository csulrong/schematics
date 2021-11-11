
variable "resource_group_name" {
  default = "friday-you"
}

variable "cos" {
  type = object({
    service_name = string
    instance_name = string
    plan = string
    location = string
    bucket_name = string
    bucket_location = string
    bucket_storage_class = string
  })
  default = {
    service_name = "cloud-object-storage"
    instance_name = "friday-you-object-storage-jet"
    plan = "standard"
    location = "global"
    bucket_name = "friday-you-images"
    bucket_location = "us-south"
    bucket_storage_class = "smart"
  }
}

variable "cis" {
  type = object({
    service_name = string
    instance_name = string
    plan = string
    location = string
    domain_name = string
  })
  default = {
    service_name = "cloud-internet-services"
    instance_name = "friday-you-cis-jet"
    plan = "trial"
    location = "global"
    domain_name = "friday-you.cns-foo.com"
  }
}

variable "web" {
  type = object({
    hostname = string
    address = string
  })

  default = {
    hostname = "friday-you.cns-foo.com"
    address = "150.238.49.45"
  }
}