resource "aws_elastic_beanstalk_environment" "env" {
  name                = var.environment_name
  application         = var.application_name
  platform_arn        = "arn:aws:elasticbeanstalk:ap-south-1::platform/Tomcat 9 with Corretto 17 running on 64bit Amazon Linux 2023/5.10.0"

  version_label = var.version_label

  setting {
  namespace = "aws:autoscaling:launchconfiguration"
  name      = "IamInstanceProfile"
  value     = aws_iam_instance_profile.beanstalk_ec2_instance_profile.name
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.instance_type
  }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "ImageId"
  #   value     = var.custom_ami_id
  # }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ec2_key_name}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnets)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = join(",", var.security_groups)
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.certificate_arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

}

resource "aws_iam_role" "beanstalk_ec2_role" {
    name = "beanstalk-ec2-role"

    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }]
    })
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_role_attachment" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_ec2_instance_profile" {
  name = "beanstalk-ec2-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}
