locals {
  app_domain                  = module.web-app.app_domain
  private_subnets_cidr_blocks = module.web-app.private_subnets_cidr_blocks
  public_subnets_cidr_blocks  = module.web-app.public_subnets_cidr_blocks
  vgw_id                      = module.web-app.vgw_id
}

################################################################################
# Environment Outputs
################################################################################

output "app_domain" {
  description = "DNS"
  value       = local.app_domain
}

output "private_subnets_cidr_blocks" {
  description = "private_subnets_cidr_blocks"
  value       = local.private_subnets_cidr_blocks
}

output "public_subnets_cidr_blocks" {
  description = "public_subnets_cidr_blocks"
  value       = local.public_subnets_cidr_blocks
}

output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = local.vgw_id
}
