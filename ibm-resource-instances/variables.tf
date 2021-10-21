
variable "resource_group_name" {
  default = "friday-you"
}
variable "cos" {
  type = object({
    service_name = string
    instance_name = string
    plan = string
    location = string
  })
  default = {
    service_name = "cloud-object-storage"
    instance_name = "friday-you-object-storage-jet"
    plan = "standard"
    location = "global"
  }
}

# variable "cis" {
#   type = object({
#     service_name = string
#     instance_name = string
#     plan = string
#     location = string
#     domain_name = string
#   })
#   default = {
#     service_name = "cloud-internet-services"
#     instance_name = "friday-you-cloud-internet-services-jet"
#     plan = "standard"
#     location = "global"
#     domain_name = "friday-you.cns-foo.com"
#   }
# }
