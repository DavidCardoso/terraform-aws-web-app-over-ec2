################################################################################
# Stack
################################################################################

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "prefix" {
  type        = string
  description = "Resource name prefix"
}

variable "stack_id" {
  type        = string
  description = "Random string. Suffix to use when creating resources (name, tag)."
}

variable "tags" {
  type        = map(string)
  description = "Default tags"
}

variable "deployment" {
  type        = string
  description = "Deployment ID"
}

variable "account_id" {
  type        = number
  description = "AWS Account ID"
}

################################################################################
# DNS
################################################################################
variable "subdomain" {
  type        = string
  description = "Subdomain for the app."
}

variable "domain" {
  type        = string
  description = "Hosted Zone name. It must be an existent one."
}

################################################################################
# VPC
################################################################################

variable "vpc_name" {
  type        = string
  description = "VPC custom name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR (network address / mask)."
}

variable "vpc_azs" {
  type        = list(string)
  description = "VPC Availability Zones."
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "VPC subnet for private resources."
}

variable "vpc_database_subnets" {
  type        = list(string)
  description = "A dedicated private subnet for databases."
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "VPC subnet for public resources."
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  description = "If a NAT gateway should be created/enabled."
}

variable "vpc_single_nat_gateway" {
  type        = bool
  description = "If just one NAT gateway should be shared by all AZs. Otherwise, each AZ will have a dedidated NAT gateway (more expensive but more reliable)."
}

variable "vpc_enable_vpn_gateway" {
  type        = bool
  description = "If a VPN gateway should be created/enabled."
}

variable "vpc_enable_ipv6" {
  type        = bool
  description = "If ipv6 should be enabled for the VPC."
}

variable "vpc_enable_flow_log" {
  type        = bool
  description = "If VPC flow logs should be enabled for the VPC."
}

################################################################################
# EC2 / Autoscalling Group
################################################################################

variable "asg_min_size" {
  type        = number
  description = "Minimum quantity of EC2 instances"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum quantity of EC2 instances"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired quantity of EC2 instances"
}

variable "ec2_instance_type" {
  type        = string
  description = "Class and size of the instance (e.g., t3.micro)."
}

variable "ec2_instance_market" {
  type        = string
  default     = ""
  description = "Purchase/billing option. Inform 'spot' or leave it empty."
}

variable "ec2_image_id" {
  type        = string
  default     = "ami-0c9e7cbc8f9f6446b"
  # default     = "resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  description = "Amazon Linux AMI ID. It can be an ID or in a 'resolve:ssm:/' query format. See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-an-ami-aws-cli"
}

variable "ec2_user_data" {
  type        = string
  default     = ""
  description = "A base64-encoded string based on the content of a file. It can be used to do basic configurations in the EC2 instance."
}

################################################################################
# Load Balancer
################################################################################

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "If 'true', terraform won't be able to destroy the ALB."
}
