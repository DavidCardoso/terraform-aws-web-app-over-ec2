module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.9.0"

  name = local.alb_name

  load_balancer_type = "application"

  enable_deletion_protection = local.alb_enable_deletion_protection

  vpc_id = module.vpc.vpc_id

  # Use `subnets` if you don't want to attach EIPs
  subnets = module.vpc.public_subnets

  security_groups = [
    module.sg_alb.security_group_id,
  ]

  # TODO: review it according to the compliance rules
  access_logs = {
    bucket = module.log_bucket_for_alb.s3_bucket_id
    prefix = "access-logs"
  }

  # TODO: review it according to the compliance rules
  connection_logs = {
    bucket  = module.log_bucket_for_alb.s3_bucket_id
    enabled = true
    prefix  = "connection-logs"
  }

  target_groups = {
    instances = {
      name        = local.alb_tg_name
      vpc_id      = module.vpc.vpc_id
      target_type = "instance"
      protocol    = "HTTP"
      protocol_version = "HTTP1"
      port        = 80

      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        interval            = 30
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      # This target group starts with one instance by default
      # Note: the ASG will add more if needed
      target_id = aws_instance.app.id

      tags = local.tags
    }
  }

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
    https = {
      port              = 443
      protocol          = "HTTPS"
      ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn   = module.acm.acm_certificate_arn

      forward = {
        target_group_key = "instances"
      }
    }
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

# Security group for ALB
module "sg_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  name        = local.vpc_security_group_names.alb
  description = "ALB security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}
