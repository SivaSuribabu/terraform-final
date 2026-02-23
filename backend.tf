terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-21-02-2026"
    key            = "beanstalk/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
    encrypt        = true
  }
}