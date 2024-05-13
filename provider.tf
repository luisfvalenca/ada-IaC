# Provedor AWS
provider "aws" {
	access_key = var.access_key
	secret_key = var.secret_key
	region = var.aws_region
#	s3_use_path_style = true
#	endpoints {
#		ec2 = "http://localhost:4566"
#		s3 = "http://s3.localhost.localstack.cloud:4566"
#	}
}
