resource "aws_elastic_beanstalk_application" "app" {
  name        = var.application_name
  description = "Enterprise Beanstalk Application"
}

data "aws_region" "current" {}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "${var.application_name}-v1"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = var.s3_bucket
  key         = var.s3_key

  lifecycle {
    precondition {
      condition     = var.s3_bucket_region == null || var.s3_bucket_region == data.aws_region.current.name
      error_message = "Elastic Beanstalk source bundle bucket must be in the same region as the AWS provider. Set s3_bucket_region to match provider region ${data.aws_region.current.name}, or use an S3 bucket in that region."
    }
  }
}