#!/bin/bash
#
##############################################################################
# Criado por: Samuel Galdino                                                 #
# Comunix Tecnologia                                                         #
# Data: 20/08/2024                                                           #
# Contato:                                                                   #
#         https://www.linkedin.com/in/samuel-silva-08a876207/                #
#                                                                            #
##############################################################################
#
############################################################################
#                                                                          #
#       DESCRIÇÃO:                                                         #
#                                                                          #
#       O OBJETIVO DO SCRIPT É FACILITAR O BALANCEAMENTO DE GRAVAÇÕES      #
#                                                                          #
#                                                                          #
#                                                                          #
############################################################################

echo '################################################################################'
echo '  O OBJETIVO DO SCRIPT É FACILITAR O BALANCEAMENTO DE GRAVAÇÕES'
echo '################################################################################'

sleep 2

df -h

sleep 2

GRAVACAO_ORIGEM='/home/gravacoes'
DESTINO1='/home2/gravacoes'
DESTINO2='/home3/gravacoes/'

# Solicitar ao usuário que escolha o destino
echo "Escolha o destino para o rsync:"
echo "1) $DESTINO1"
echo "2) $DESTINO2 "
read -p "Digite o número correspondente ao destino desejado (1 ou 2): " escolha

# Definir o DESTINO com base na escolha do usuário
if [ "$escolha" -eq 1 ]; then
    DESTINO=$DESTINO1
elif [ "$escolha" -eq 2 ]; then
    DESTINO=$DESTINO2
else
    echo "Escolha inválida. Saindo."
    exit 1
fi

sleep 2

echo '################################################################################'
echo '################################################################################'

# Solicitar o diretório de origem
echo 'Dentro das pastas de gravações, temos: '

echo ' '

ls $GRAVACAO_ORIGEM

echo ' '

echo '################################################################################'
echo '################################################################################'
echo ' '

echo 'DIGITE O DIRETÓRIO DE ORIGEM PARA ACESSAR E REALIZAR A CÓPIA DAS GRAVAÇÕES'
read PASTA

# Verificar se o diretório existe
if [ ! -d "$GRAVACAO_ORIGEM/$PASTA" ]; then
    echo "Diretório de origem não encontrado."
    exit 1
fi

# Solicitar a data de modificação
echo ' '
ls $GRAVACAO_ORIGEM/$PASTA
echo 'DIGITE A DATA QUE DESEJA BUSCAR (Formato: AAAA-MM-DD)'
read DATA

# Navegar até o diretório especificado
cd "$GRAVACAO_ORIGEM/$PASTA"

# Encontrar arquivos modificados exatamente na data especificada
ARQUIVOS=$(find $GRAVACAO_ORIGEM/$PASTA/$DATA -type f | grep -E 'wav|WAV|mp3|MP3|avi')


# Verificar se foram encontrados arquivos
if [ -z "$ARQUIVOS" ]; then
    echo "Nenhum arquivo encontrado na data especificada."
    exit 1
fi

# Executar o rsync para cada arquivo encontrado
for ARQUIVO in $ARQUIVOS;
do
        #DATA_LINHA=$(ls $ARQUIVO | tr -d " " | awk -F "*" {'print $0'})
        DATA_LINHA=$(echo $ARQUIVO | tr -d " " | awk -F "/" {'print $5'})
        if
                [ -d "$DESTINO/$PASTA/$DATA_LINHA" ]; then
                echo "O diretorio existe"
        else
                echo "O diretorio não existe"
        mkdir -p "$DESTINO/$PASTA/$DATA_LINHA"
        fi
        sleep 1
        echo ' '
        rsync -azhP --remove-source-files "$ARQUIVO" "$DESTINO/$PASTA/$DATA_LINHA"
        echo "$ARQUIVO copiado para: $DESTINO/$PASTA/$DATA_LINHA"

        COPIA="$DESTINO/$PASTA/$DATA_LINHA/$ARQUIVO"

done

