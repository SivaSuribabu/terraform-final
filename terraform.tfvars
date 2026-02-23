region             = "ap-south-1"

application_name   = "uat-app"
environment_name   = "uat-env"

s3_bucket          = "terraform-root-file-bucket-uat"
s3_key             = "ROOT.war"
s3_bucket_region   = "ap-south-1"

instance_type      = "t3.micro"
# custom_ami_id      = "ami-001ba891bac21c32c"
ec2_key_name       = "account-1-ap-south-1"

vpc_id             = "vpc-089a69f9765b6bd52"
public_subnets     = ["subnet-0108669173b478aa0", "subnet-04ea9ba32d0776e2d"]
private_subnets    = ["subnet-0108669173b478aa0", "subnet-04ea9ba32d0776e2d"]

security_groups    = ["sg-0396c384f14018603"]

certificate_arn    = "arn:aws:acm:ap-south-1:644209053375:certificate/a4cf6ec6-8014-4fb5-b615-f5f3900b881e"
domain_name        = "www.devopswithsiva.info"
hosted_zone_id     = "Z02290621JSSHZ17I48K3"