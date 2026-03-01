# ============================================================================
#ELASTIC BEANSTALK APPLICATION
# ============================================================================
# Application name - must be unique within the AWS account
resource "aws_elastic_beanstalk_application" "beanstalk_app" {
name = var.app_name
description = var.description

  tags = merge(
    {
      Name = var.app_name
    },
    var.tags
  )
}

# ============================================================================
# IAM ROLE FOR EC2 INSTANCES
# ============================================================================
# This role is assumed by EC2 instances running in the Elastic Beanstalk environment
# It defines what AWS services and resources the instances can access

resource "aws_iam_role" "ecsInstanceRole" {
# This is required by AWS for instance profiles used with Elastic Beanstalk
  name = "${var.app_name}-ecsInstanceRole-${var.environment_name}"

  # Trust policy that allows EC2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Allows the EC2 service to assume this role
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.app_name}-ecsInstanceRole"
    },
    var.tags
  )
}

# ============================================================================
# ATTACH AWS MANAGED POLICIES TO EC2 INSTANCE ROLE
# ============================================================================
# AWS Elastic Beanstalk platform-specific policy for EC2 instances
# Attaches the AWS managed policy for Beanstalk EC2 instances
# This grants permissions for the Beanstalk agent to operate
resource "aws_iam_role_policy_attachment" "ecsInstanceRolePolicy" {
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach policy for S3 bucket access
resource "aws_iam_role_policy_attachment" "s3AccessPolicy" {
  # Allows EC2 instances to access S3 for downloading application code
  # and uploading logs
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# CloudWatch policy attachment removed per request.
# Custom policy for Elastic Beanstalk specific operations
resource "aws_iam_role_policy_attachment" "elasticBeanstalkPolicy" {
  # AWS managed policy specific to Elastic Beanstalk workloads
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

# SQS access policy for worker environments (if needed)
resource "aws_iam_role_policy_attachment" "sqsPolicy" {
  # Allows EC2 instances to access SQS for asynchronous message processing
  role       = aws_iam_role.ecsInstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# ============================================================================
# EC2 INSTANCE PROFILE
# ============================================================================
# The instance profile is a container for the IAM role
# It's used to pass the role to EC2 instances when they are launched

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  # Instance profile name - must match the pattern for Elastic Beanstalk
  name = "${var.app_name}-ecsInstanceProfile-${var.environment_name}"

  # Associates the IAM role with the instance profile
  role = aws_iam_role.ecsInstanceRole.name
}

# ============================================================================
# IAM ROLE FOR ELASTIC BEANSTALK SERVICE
# ============================================================================
# This role is assumed by the Elastic Beanstalk service itself
# It grants permissions for Beanstalk to manage resources on your behalf

resource "aws_iam_role" "ecsServiceRole" {
  name = "${var.app_name}-ecsServiceRole-${var.environment_name}"

  # Trust policy allowing Elastic Beanstalk service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Allows the Elastic Beanstalk service to assume this role
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      },
      {
        # Allows AWS autoscaling service to assume this role (for auto-scaling operations)
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.app_name}-ecsServiceRole"
    },
    var.tags
  )
}

# ============================================================================
# ATTACH AWS MANAGED POLICIES TO SERVICE ROLE
# ============================================================================

# AWS Elastic Beanstalk service role policy
resource "aws_iam_role_policy_attachment" "ecsServiceRolePolicy" {
  # AWS managed policy granting Elastic Beanstalk service permissions
  # to create and manage environments, instances, and related resources
  role       = aws_iam_role.ecsServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "ecsServiceRolePolicy2" {
  # Additional AWS managed policy for Elastic Beanstalk service
  role       = aws_iam_role.ecsServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Auto Scaling policy for the service role
resource "aws_iam_role_policy_attachment" "ecsServiceRole" {
  # Grants permissions for auto-scaling operations
  role       = aws_iam_role.ecsServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}