# DNS record
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.app_domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

# SSL certificate
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name  = local.app_domain_name
  zone_id      = data.aws_route53_zone.this.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${local.app_domain_name}",
  ]

  wait_for_validation = true

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

# The Hosted Zone must already exist
data "aws_route53_zone" "this" {
  name = local.hosted_zone_name
}
