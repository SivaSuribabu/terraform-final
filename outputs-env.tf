output "environment_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "beanstalk_cname" {
  value = aws_elastic_beanstalk_environment.env.cname
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.env.name
}