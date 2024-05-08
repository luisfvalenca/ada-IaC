# Provedor AWS

provider "aws" {
	access_key			= "mock_access_key"  # Chave de acesso para autenticar na AWS
	secret_key			= "mock_secret_key"  # Chave secreta para autenticar na AWS
	region				= "us-east-1"  # Região da AWS onde os recursos serão provisionados
	s3_use_path_style		= true  # Define o estilo de URL para acessar o serviço S3
	skip_credentials_validation	= true  # Ignora a validação das credenciais de autenticação
	skip_metadata_api_check		= true  # Ignora a verificação da API de metadados
	skip_requesting_account_id	= true  # Ignora a solicitação do ID da conta
    endpoints {
	ec2 = "http://localhost:4566"
	s3 = "http://s3.localhost.localstack.cloud:4566"  # URL do serviço S3 -> para acessar o index do LocalStack basta adicionar /bucket1/index.html
    }
}
