output "application_name" {
  value = aws_elastic_beanstalk_application.app.name
}

output "version_label" {
  value = aws_elastic_beanstalk_application_version.app_version.name
}