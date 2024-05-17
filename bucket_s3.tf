# Recurso Bucket S3
resource "aws_s3_bucket" "bucket" {
	bucket = "bucket-${var.project_name}-${terraform.workspace}"
	tags = {
		Nome = "bucket-${var.project_name}-${terraform.workspace}"
		Environment = terraform.workspace
	}
}

# Configure website hosting for the bucket
resource "aws_s3_bucket_website_configuration" "website" {
	bucket = aws_s3_bucket.bucket.id
	index_document {
		suffix = "index.html"
	}
}

# Recurso Objeto do Bucket S3
resource "aws_s3_bucket_object" "html_file" {
	bucket = aws_s3_bucket.bucket.id
	key = "index.html"
	source = "index.html"
	content_type = "text/html"
}

# Configure public access block for the bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
	bucket = aws_s3_bucket.bucket.id
	block_public_acls       = false
	block_public_policy     = false
	ignore_public_acls      = false
	restrict_public_buckets = false
}

# Política do Bucket S3
resource "aws_s3_bucket_policy" "bucket_policy" {
	bucket = aws_s3_bucket.bucket.id
	policy = <<POLICY
	{
		"Version":"2012-10-17",
		Statement":[
        	{
				"Sid":"AddPublicReadAccess",
				"Effect":"Allow",
				"Principal": "*",
				"Action":["s3:GetObject"],
				"Resource":["${aws_s3_bucket.bucket.arn}/*"]
        	}
    	]
	}
POLICY
}
