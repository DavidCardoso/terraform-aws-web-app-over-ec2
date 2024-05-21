module "log_bucket_for_alb" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.1.2"

  bucket = local.alb_log_bucket_name
  acl    = "log-delivery-write"

  # TODO: update it according to the compliance rules
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = local.tags
}
