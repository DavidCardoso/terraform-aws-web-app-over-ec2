# EC2 instance for the app
resource "aws_instance" "app" {
  subnet_id = element(module.vpc.public_subnets, 0)

  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }
}

# Autoscaling Group
module "asg_for_alb" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "~> 5.1.0"

  name = local.alb_autoscaling_group_name

  vpc_zone_identifier = module.vpc.public_subnets

  # capacity
  min_size            = local.asg_min_size
  max_size            = local.asg_max_size
  desired_capacity    = local.asg_desired_capacity

  # Launch template
  create_launch_template = false
  launch_template        = aws_launch_template.this.name
  launch_template_version = aws_launch_template.this.latest_version

  # Target Groups
  target_group_arns = [module.alb.target_groups.instances.arn]

  tags = local.tags
}

# EC2 Launch Template
resource "aws_launch_template" "this" {
  name_prefix   = "${local.instance_name}-"
  image_id      = local.ec2_image_id

  instance_type = local.ec2_instance_type

  instance_market_options {
    market_type = local.ec2_instance_market
    # use `spot_options` object to customize it
  }

  instance_initiated_shutdown_behavior = "terminate"

  vpc_security_group_ids = [module.ec2_sg.security_group_id]

  user_data = local.ec2_user_data

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Supporting resources
################################################################################

# Security group for EC2 instance
module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  name        = local.vpc_security_group_names.ec2_instance
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

# Security Group for Autoscaling Group
module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  name        = local.vpc_security_group_names.asg_for_alb
  description = "Security group for the ASG used with the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}
