# development environment
locals {
  # General
  environment = var.environment
  tags = merge(
    var.tags,
    {
      # add more custom tags if needed
    }
  )

  # App
  # TODO: create prefix validation
  app_name = var.prefix # Should be in slug format. Do not include the final `-` (dash)
  app_server_port = 80 # NGINX default
  app_domain_name = "${var.subdomain}.${var.domain}"

  # Route53 / ACM
  hosted_zone_name = var.domain
  certificate_arn  = module.acm.acm_certificate_arn

  # VPC
  vpc_name                  = var.vpc_name
  vpc_cidr                  = var.vpc_cidr
  vpc_azs                   = var.vpc_azs
  vpc_private_subnets       = var.vpc_private_subnets
  vpc_database_subnets      = var.vpc_database_subnets
  vpc_public_subnets        = var.vpc_public_subnets
  vpc_security_group_names  = {
    # If needed, add more names following this pattern
    ec2_instance  = "${var.deployment}-ec2-instance-sg"
    asg_for_alb   = "${var.deployment}-asg-for-alb-sg"
    alb           = "${var.deployment}-alb-sg"
  }

  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway = var.vpc_single_nat_gateway
  vpc_enable_vpn_gateway = var.vpc_enable_vpn_gateway
  vpc_enable_ipv6        = var.vpc_enable_ipv6
  vpc_enable_flow_log    = var.vpc_enable_flow_log

  # ALB
  alb_name                    = "${var.deployment}-alb"
  alb_log_bucket_name         = "${local.alb_name}-logs"
  alb_autoscaling_group_name  = "${var.deployment}-asg"
  alb_tg_name                 = "${var.deployment}-tg"
  alb_enable_deletion_protection = var.alb_enable_deletion_protection

  # EC2 / Autoscalling Group
  instance_name         = "${var.deployment}-instance"
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  ec2_instance_type     = var.ec2_instance_type
  ec2_instance_market   = var.ec2_instance_market
  ec2_image_id          = var.ec2_image_id
  ec2_user_data         = var.ec2_user_data
}
