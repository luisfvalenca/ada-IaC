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
echo "${USER}:senha" | chpasswd
#sudo passwd -q -d $USER
#sudo passwd -q -l $USER
# Escreve chave publica
sudo mkdir -p /home/$USER/.ssh
sudo echo "$PUBKEY" > /home/$USER/.ssh/authorized_keys
echo "Arquivo /home/$USER/.ssh/authorized_keys criado:"
sudo cat /home/$USER/.ssh/authorized_keys
# Adiciona ao AllowGroups do ssh
sudo sed -i '/RSAAuth/d' /etc/ssh/sshd_config
sudo sed -i '/PubkeyAuth/d' /etc/ssh/sshd_config
sudo sed -i '/AllowGroups/d' /etc/ssh/sshd_config
sudo echo 'RSAAuthentication yes' >> /etc/ssh/sshd_config
sudo echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
sudo echo "AllowGroups $USER" >> /etc/ssh/sshd_config
sudo systemctl restart sshd
# Da permissao de sudo
sudo echo "$USER ALL=NOPASSWD: ALL" > /etc/sudoers.d/$USER
echo "Arquivo /etc/sudoers.d/$USER criado:"
sudo cat /etc/sudoers.d/$USER