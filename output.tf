output "bucket_name" {
    value = aws_s3_bucket.bucket.bucket
    description = "Nome do bucket criado"
}