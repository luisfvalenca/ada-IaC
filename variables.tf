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
  default = "projeto-luisfvalenca"
}