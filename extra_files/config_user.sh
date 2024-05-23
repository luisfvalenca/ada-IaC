#!/bin/bash

# Captura variaveis passadas pelo Terraform
USER=${tf_ansible_user}
PUBKEY=${tf_ansible_pubkey}

# Garante pacotes necessarios ao ansible instalados na instancia
sudo apt update
sudo apt install python3 openssh-server -y

# Cria e configura o usuario do ansible
echo "Criando user: $USER ..."
sudo useradd \
    --create-home \
    --comment "Usuario para o Ansible" \
    --shell /bin/bash \
    $USER
# Desabilita senha
sudo passwd -q -d $USER
sudo passwd -q -l $USER
# Escreve chave publica
sudo mkdir -p /home/$USER/.ssh
sudo echo "$PUBKEY" > /home/$USER/.ssh/authorized_keys
# Da permissao de sudo
sudo echo "$USER ALL=NOPASSWD: ALL" > /etc/sudoers.d/$USER