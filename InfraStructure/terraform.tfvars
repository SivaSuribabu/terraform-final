# ============================================================================
# TERRAFORM VARIABLES FILE (terraform.tfvars)
# ============================================================================


# ============================================================================
# AWS REGION
# ============================================================================
# AWS region where all resources will be deployed
# For India region, use ap-south-1
aws_region = "ap-south-1"

# ============================================================================
# PROJECT AND ENVIRONMENT NAMING
# ============================================================================
# Project name for resource naming and tagging
project_name = "indian-eagle-uat-infra"

# Environment name for resource naming and tagging (dev, staging, uat, prod)
environment_name = "ieagle-uat-env"

# ============================================================================
# ELASTIC BEANSTALK APPLICATION CONFIGURATION
# ============================================================================
# Name for the Elastic Beanstalk application
app_name = "ieagle-uat-application"

# Name for the Elastic Beanstalk environment
env_name = "ieagle-uat-environment"


# Using: 64bit Amazon Linux 2 v5.8.2 running Tomcat 9 Corretto 11
solution_stack_name = "64bit Amazon Linux 2023 v5.11.0 running Tomcat 9 Corretto 11"
# "Corretto 11 running on 64bit Amazon Linux 2023/4.9.0"

# ============================================================================
# EC2 INSTANCE CONFIGURATION
# ============================================================================
# t3.medium is suitable for most applications (2 vCPU, 4GB RAM)
# Other options: t3.small, t3.large, t3.xlarge, m5.large, etc.
instance_type = "t3.medium"


# AMI ID for the EC2 instances (must be compatible with the solution stack)
ami_id = "ami-0008ec1ec9865a5cd"
# ============================================================================
# AUTO-SCALING CONFIGURATION
# ============================================================================
# Minimum number of EC2 instances to maintain (even when load is low)
min_size = 1

# Maximum number of EC2 instances that can be launched (when load is high)
max_size = 1

# ============================================================================
# NETWORKING CONFIGURATION
# ============================================================================
# IMPORTANT: Replace these with your actual AWS VPC and Subnet IDs

# VPC ID where the Beanstalk environment will be deployed
# Example format: vpc-0123456789abcdef0
vpc_id = "vpc-022db108ebbe4d4d4"

# List of private subnet IDs for EC2 instances
# EC2 instances will be placed in these private subnets for security
# Provide at least 2 subnets for high availability
# Example format: ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
private_subnets = ["subnet-0a15856df8b0df84d", "subnet-068d91f86866c8e57"]

# List of public subnet IDs for the Application Load Balancer
# The ALB will be internet-facing in these public subnets
# Example format: ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
public_subnets = ["subnet-0a15856df8b0df84d", "subnet-068d91f86866c8e57"]

# ============================================================================
# CUSTOM DOMAIN AND SSL/TLS CONFIGURATION
# ============================================================================
# IMPORTANT: Replace these with your actual domain and certificate

# Custom domain name for the application
# This will be configured to point to the load balancer
custom_domain = "uat.spieagle.com"

# ARN of the AWS Certificate Manager (ACM) certificate for HTTPS/SSL
# The certificate must be issued for the custom domain
# Format: arn:aws:acm:ap-south-1:123456789012:certificate/12345678-1234-1234-1234-123456789012
# To get your ACM certificate ARN, run: aws acm list-certificates --region ap-south-1
acm_certificate_arn = "arn:aws:acm:ap-south-1:571355911189:certificate/ebb08b34-a6f3-41e7-a37f-4ad2a0136089"

# ============================================================================
# APPLICATION SOURCE CODE CONFIGURATION
# ============================================================================
# IMPORTANT: Ensure the S3 bucket and WAR file exist before deployment

# S3 bucket name containing the application WAR file
# The bucket must be in the same region (ap-south-1)
# The bucket must allow Beanstalk EC2 instances to read the files
source_code_bucket = "ie-uat-infra"

# S3 object key (path) of the WAR file within the bucket
# Example: "releases/app-1.0.0.war"
source_code_key = "ie-uat-source-code/ROOT.war"

# ============================================================================
# HEALTH CHECK CONFIGURATION
# ============================================================================
# Or a specific health endpoint like "/health" or "/actuator/health"
health_check_path = "/"

# Number of consecutive successful health checks before marking instance healthy
healthy_threshold = 5

# Number of consecutive failed health checks before marking instance unhealthy
unhealthy_threshold = 7

# Interval between health checks in seconds
health_check_interval = 30

# Timeout for health check response in seconds
health_check_timeout = 5

# ============================================================================
# HTTPS/SSL CONFIGURATION
# ============================================================================
# Enable HTTP to HTTPS redirect
# All HTTP traffic will be automatically redirected to HTTPS
enable_https_redirect = true