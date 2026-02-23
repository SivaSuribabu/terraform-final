variable "application_name" {}
variable "s3_bucket" {}
variable "s3_key" {}
variable "s3_bucket_region" {
	type    = string
	default = null
}