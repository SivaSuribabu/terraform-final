module "beanstalk_app" {
  source = "./modules/beanstalk_app"

  application_name = var.application_name
  s3_bucket        = var.s3_bucket
  s3_key           = var.s3_key
  s3_bucket_region = var.s3_bucket_region
}

module "beanstalk_env" {
  source = "./modules/beanstalk_env"

  application_name  = module.beanstalk_app.application_name
  environment_name  = var.environment_name
  version_label     = module.beanstalk_app.version_label

  instance_type     = var.instance_type
  # custom_ami_id     = var.custom_ami_id
  ec2_key_name      = var.ec2_key_name

  vpc_id            = var.vpc_id
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  security_groups   = var.security_groups

  certificate_arn   = var.certificate_arn
  domain_name       = var.domain_name
  hosted_zone_id    = var.hosted_zone_id
}

data "aws_lb" "beanstalk_alb" {
  depends_on = [module.beanstalk_env]

  tags = {
    "elasticbeanstalk:environment-name" = module.beanstalk_env.environment_name
  }
}

data "aws_route53_zone" "env" {
  name         = "www.devopswithsiva.info."
  private_zone = false
}

resource "aws_route53_record" "app_dns" {
  zone_id = data.aws_route53_zone.env.zone_id
  name    = "www"   # IMPORTANT: only subdomain
  type    = "A"

  alias {
    name                   = data.aws_lb.beanstalk_alb.dns_name
    zone_id                = data.aws_lb.beanstalk_alb.zone_id
    evaluate_target_health = true
  }
}