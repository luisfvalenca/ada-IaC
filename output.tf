output "bucket_name" {
    value = aws_s3_bucket.bucket.bucket
    description = "Nome do bucket criado"
}

output "app_public_ip" {
    value = aws_instance.app.public_ip
    description = "IP publico da instancia de aplicacao"
}