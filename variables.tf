variable "aws_region" {
  description = "Região da AWS para provisionar os recursos"
  type = string
  default = "us-east-1"
}

variable "aws_access_key" {
  description = "Access Key ID da AWS"
  type = string
}

variable "aws_secret_key" {
  description = "Secret Access Key da AWS"
  type = string
}

variable "project_name" {
  description = "Nome do projeto"
  type = string
  default = "projeto-ada-iac"
}

variable "ansible_user" {
  description = "Usuario para o Ansible"
  type = string
  default = "ansibleusr"
}

variable "ansible_pubkey" {
  description = "Chave publica do usuario para o Ansible"
  type = string
}

variable "ami_image" {
  description = "ID da imagem AMI (EC2)"
  type = string
  # AMI Debian 12 (bookworm) para us-east-1
	default = "ami-05d2416d3dc5a7165"
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type = string
  default = "t2.micro"
}