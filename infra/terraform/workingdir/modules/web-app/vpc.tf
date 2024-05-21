module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = local.vpc_name
  azs  = local.vpc_azs
  cidr = local.vpc_cidr

  public_subnets   = local.vpc_public_subnets
  private_subnets  = local.vpc_private_subnets
  database_subnets = local.vpc_database_subnets

  enable_nat_gateway = local.vpc_enable_nat_gateway
  single_nat_gateway = local.vpc_single_nat_gateway
  enable_vpn_gateway = local.vpc_enable_vpn_gateway

  enable_flow_log = local.vpc_enable_flow_log

  enable_ipv6 = local.vpc_enable_ipv6

  tags = local.tags
}
