# Recurso Bucket S3
resource "aws_s3_bucket" "bucket1" {
	bucket = "bucket1"  # Nome do bucket S3
	website {
		index_document = "index.html"  # Documento de índice para o bucket S3
    }
}

# Recurso Objeto do Bucket S3
resource "aws_s3_bucket_object" "html_file" {
	bucket		= aws_s3_bucket.bucket1.id  # ID do bucket S3
	key		= "index.html"  # Chave do objeto no bucket S3
	source		= "index.html"  # Caminho do arquivo de origem
	acl		= "public-read"  # Permissões de acesso ao objeto
	content_type	= "text/html"  # Tipo de conteúdo do objeto
}

# Política do Bucket S3
resource "aws_s3_bucket_policy" "bucket_policy" {
	bucket = aws_s3_bucket.bucket1.id  # ID do bucket S3
	policy = jsonencode({
		Version = "2012-10-17"  # Versão da política
		Statement = [{
			Effect		= "Allow"  # Efeito da política
			Principal	= "*"  # Principal da política
			Action		= "s3:GetObject"  # Ação permitida pela política
			Resource	= "${aws_s3_bucket.bucket1.arn}/*"  # Recurso ao qual a política se aplica
		}]
	})
}
