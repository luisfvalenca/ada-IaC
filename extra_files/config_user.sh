#!/bin/bash

# Garante pacotes necessarios ao ansible instalados na instancia
sudo apt update
sudo apt install ansible python3 openssh-server -y

# Cria e configura o usuario do ansible
echo "Criando user: $ansible_user ..."
sudo useradd \
    --create-home \
    --comment "Usuario para o Ansible" \
    --shell /bin/bash \
    $ansible_user
# Desabilita senha
sudo passwd -q -d $ansible_user
sudo passwd -q -l $ansible_user
# Escreve chave publica
sudo mkdir -p /home/$ansible_user/.ssh
sudo echo "$ansible_pubkey" > /home/$ansible_user/.ssh/authorized_keys
# Da permissao de sudo
sudo echo "$ansible_user ALL=NOPASSWD: ALL" > /etc/sudoers.d/$ansible_user