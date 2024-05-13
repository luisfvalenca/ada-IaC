# Recurso Bucket S3
resource "aws_s3_bucket" "bucket" {
	bucket = "bucket-{var.project_name}-{terraform.workspace}"
	tags = {
		Nome = "bucket-{var.project_name}-{terraform.workspace}"
		Environment = terraform.workspace
	}
	website {
		index_document = "index.html"
    }
}

# Recurso Objeto do Bucket S3
resource "aws_s3_bucket_object" "html_file" {
	bucket = aws_s3_bucket.bucket.id
	key = "index.html"
	source = "index.html"
	acl = "public-read"
	content_type = "text/html"
}

# Política do Bucket S3
resource "aws_s3_bucket_policy" "bucket_policy" {
	bucket = aws_s3_bucket.bucket.id
	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Effect = "Allow"
			Principal = "*"
			Action = "s3:GetObject"
			Resource = "${aws_s3_bucket.bucket.arn}/*"
		}]
	})
}
