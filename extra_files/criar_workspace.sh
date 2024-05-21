#!/bin/bash

#Validan entrada de dados
if [ $# -ne 1 ]
then
    echo 'ERRO! Informe o workspace como parametro...'
    echo "exemplo: $0 prod"
    exit 1
fi
workspace=$1

#Valida se ha arquivos terraform
ls ../*.tf &> /dev/null
[ "$?" == "0" ] && cd ..
ls ./*.tf &> /dev/null
if [ "$?" != "0" ]
then
    echo "ERRO! Nao foi possivel encontrar arquivos .tf (terraform)"
    exit 1
fi
tfvars_file=$workspace.tfvars

echo "Iniciando entrada de dados..."
echo "se vazio sera definido valor default!"

#Le nome do projeto
read -p 'Nome do projeto (default: projeto-ada-iac): ' project_name
[ -z "$project_name" ] && project_name=projeto-ada-iac

#Le regiao da AWS
read -p 'Regiao AWS (default: us-east-1): ' aws_region
[ -z "$aws_region" ] && aws_region=us-east-1

#Le aws access key (nao pode ser vazio)
while [ -z "$aws_access_key" ]
do
    read -p 'AWS access key (obrigatorio): ' aws_access_key
done

#Le AWS secret key (nao pode ser vazio, parametro -s esconde senha no terminal)
while [ -z "$aws_secret_key" ]
do
    read -s -p 'AWX secret key (obrigatorio): ' aws_secret_key
done

#Le ID da imagem AMI
echo
read -p 'ID da imagem AMI (default: ami-05d2416d3dc5a7165 [debian 12]): ' ami_image
[ -z "$ami_image" ] && ami_image=ami-05d2416d3dc5a7165

#Le tipo da instancia
read -p 'Tipo da instancia EC2 (default: t2.micro): ' instance_type
[ -z "$instance_type" ] && instance_type=t2.micro

#Le nome do ususario do ansible
read -p 'Nome do usuario Ansible (default: ansibleusr): ' ansible_user
[ -z "$ansible_user" ] && ansible_user=ansibleusr

#Cria par de chaves para usuario do ansible
ssh-keygen -q -t rsa -b 4096 -N '' -f extra_files/$ansible_user
mv extra_files/$ansible_user extra_files/$ansible_user.pem

#Carrega chave publica em variavel para escrever no .tfvars
ansible_pubkey=$(cat extra_files/$ansible_user.pub | cut -d' ' -f-2)

#Escreve dados no arquivo .tfvars
echo '' > $tfvars_file
echo "project_name = \"$project_name\"" >> $tfvars_file
echo "aws_region = \"$aws_region\"" >> $tfvars_file
echo "aws_access_key = \"$aws_access_key\"" >> $tfvars_file
echo "aws_secret_key = \"$aws_secret_key\"" >> $tfvars_file
echo "ami_image = \"$ami_image\"" >> $tfvars_file
echo "instance_type = \"$instance_type\"" >> $tfvars_file
echo "ansible_user = \"$ansible_user\"" >> $tfvars_file
echo "ansible_pubkey = \"$ansible_pubkey\"" >> $tfvars_file

#Cria workspace no terraform
terraform init
terraform workspace new $workspace
terraform workspace list

echo "Arquivo $tfvars_file criado:"
cat $tfvars_file | sed "/secret_key/d"

