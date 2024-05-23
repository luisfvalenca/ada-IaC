#!/bin/bash

#Valida entrada de dados
if [ $# -ne 1 ]
then
    echo 'ERRO! Informe o IP como parametro...'
    echo "exemplo: $0 10.123.456.789"
    exit 1
fi
IP=$1
ls ../*.tf &> /dev/null
[ "$?" == "0" ] && cd ..
PEMKEY=$(ls extra_files/*.pem)
USER=$(ls extra_files/*.pem | cut -d/ -f2 | cut -d. -f1)

ansible-playbook \
    --inventory ${IP}, \
    --user ${USER} \
    --private-key ${PEMKEY} \
    --become \
    -vv \
    extra_files/config_instance.yml &

# --become: elevacao de usuario (sudo)
# -v: nivel de verbose 1
# (quer mais verboso?: -vv, -vvv e -vvvv para conection debugging)
