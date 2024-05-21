locals {
  # stack
  prefix      = "web-app" # Slug format. Do not include the final `-` (dash)
  stack_id    = random_string.stack.id
  environment = terraform.workspace != "default" ? replace(terraform.workspace, "${local.prefix}-", "") : var.environment
  deployment  = "${local.prefix}-${local.environment}-${local.stack_id}"
  account_id  = data.aws_caller_identity.current.account_id
  tags = {
    # add more custom tags if needed
    Environment = local.environment
    Deployment  = local.deployment
    StackId     = local.stack_id
    Terraform   = "true"
    CostCenter  = "Engineering"
    App         = "web-app-over-ec2"
    Service     = "web-app"
  }

  # For critical configs, it is best to keep it as code,
  # so it is possible to control their changes via git flow.
  # TODO: review this settings - especially for production environment

  # VPC
  # Note: it assumes an empty region. Please double check it.
  vpc_name               = "${local.deployment}-vpc"
  vpc_cidr               = "10.0.0.0/16"
  vpc_azs                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  vpc_private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_database_subnets   = []
  vpc_public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  vpc_enable_nat_gateway = false
  vpc_single_nat_gateway = true
  vpc_enable_vpn_gateway = false
  vpc_enable_ipv6        = false
  vpc_enable_flow_log    = false

  # Load Balancer
  alb_enable_deletion_protection = false

  # EC2 / Autoscaling Group
  ec2_user_data = filebase64("${path.module}/scripts/nginx/start.sh")

  # It would be possible to add more variables but these are sufficient for a basic environment.
  # TODO: Add more variables as neeeded and adapt the code accordingly.
}

provider "aws" {
  region = var.region

  skip_metadata_api_check     = true
  skip_region_validation      = false
  skip_credentials_validation = false
  skip_requesting_account_id  = false
}

################################################################################
# Extra resources
################################################################################

# suffix to use when creating resources (name, tag)
# this helps to avoid resource naming conflicts
resource "random_string" "stack" {
  length  = 4
  numeric = true
  lower   = true
  upper   = false
  special = false
}

# aws account info
data "aws_caller_identity" "current" {}

################################################################################
# Manages the web app resources per environment
#
# Hint: it's recommented to create a workspace that matches the environment
# Example: `terraform workspace new ${ENVIRONMENT}`
# It will help to manage the state per environment
################################################################################
module "web-app" {
  source = "./modules/web-app"

  environment = local.environment

  # stack
  prefix     = local.prefix
  stack_id   = local.stack_id
  tags       = local.tags
  deployment = local.deployment
  account_id = local.account_id

  # DNS
  subdomain = var.subdomain
  domain    = var.domain
  region    = var.region

  # VPC
  vpc_name               = local.vpc_name
  vpc_cidr               = local.vpc_cidr
  vpc_azs                = local.vpc_azs
  vpc_private_subnets    = local.vpc_private_subnets
  vpc_database_subnets   = local.vpc_database_subnets
  vpc_public_subnets     = local.vpc_public_subnets
  vpc_enable_nat_gateway = local.vpc_enable_nat_gateway
  vpc_single_nat_gateway = local.vpc_single_nat_gateway
  vpc_enable_vpn_gateway = local.vpc_enable_vpn_gateway
  vpc_enable_ipv6        = local.vpc_enable_ipv6
  vpc_enable_flow_log    = local.vpc_enable_flow_log

  # EC2
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  ec2_instance_type    = var.ec2_instance_type
  ec2_instance_market  = var.ec2_instance_market
  ec2_user_data        = local.ec2_user_data

  # Load Balancer
  alb_enable_deletion_protection = local.alb_enable_deletion_protection
}
