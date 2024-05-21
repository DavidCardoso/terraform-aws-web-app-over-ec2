################################################################################
# Stack
################################################################################

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS Region"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "Environment"
}

################################################################################
# DNS
################################################################################

variable "subdomain" {
  type = string
  # default     = "web-app"
  description = "Subdomain of the app URL."
}

variable "domain" {
  type = string
  # default     = "code.davidcardoso.me"
  description = "Domain of the app URL. It must be an existent Hosted Zone."
}

################################################################################
# Autoscalling Group
################################################################################

variable "asg_min_size" {
  type = number
  # default     = 1
  description = "Minimum quantity of EC2 instances"
}

variable "asg_max_size" {
  type = number
  # default     = 2
  description = "Maximum quantity of EC2 instances"
}

variable "asg_desired_capacity" {
  type = number
  # default     = 2
  description = "Desired quantity of EC2 instances"
}

variable "ec2_instance_type" {
  type = string
  # default     = "t3a.nano"
  description = "Class and size of the instance (e.g., t3.micro)."
}

variable "ec2_instance_market" {
  type        = string
  default     = ""
  description = "Purchase/billing option. Inform 'spot' or leave it empty."
}
