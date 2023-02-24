#resource "null_resource" "test" {
    #provisioner "local-exec" {
      #command = "echo ${var.env}"
   # }
#}

module "vpc" {
  source = "github.com/pcs1999/tf-module-vpc"
  env = var.env
  default_vpc_id = var.default_vpc_id

  for_each = var.vpc
  cidr_block = each.value.cidr_block
  
} 


module "subnets" {
  source = "github.com/pcs1999/tf-module-vpc"
  env = var.env
  default_vpc_id = var.default_vpc_id


  for_each = var.subnets
  cidr_block = each.value.cidr_block
  availablity-zones = each.value.availablity_zones
  name = each.value.name
  vpc_id = lookup(lookup(module.vpc,each.value.vpc_name,null), "vpc_id" , null)
  vpc_peering_connection_id = lookup(lookup(module.vpc,each.value.vpc_name,null), "vpc_peering_connection_id" , null)
  internet_gw_id= lookup(lookup(module.vpc,each.value.vpc_name,null), "internet_gw" , null)
  internet_gw = lookup (each.value, "internet_gw", false)
  nat_gw = lookup (each.value, "nat_gw", false)
} 

output "vpc_id" {

  value = lookup(lookup(module.vpc,"main",null), "vpc_id" , null)
  
}

