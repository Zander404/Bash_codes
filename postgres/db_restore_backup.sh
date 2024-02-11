## backup_restore.sh
## use: sh db_restore_backup.sh backups/<NOME DO ARQ. BACKUP>
#!/bin/bash

. ./.env
set -e # Parar o código de executar, caso encontre um erro

backup_file=$1
error_file="db_backup_erro.err"

export PGPASSWORD=$DB_PASSWORD

if ! test -f "$backup_file"; then
    echo "Arquivo de backup não informado ou não encontrado"
    exit 1
fi

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME  < $backup_file -w > /dev/null 2>  $error_file
unset PGPASSWORD

if [ $? -eq 0 ]; then
        if [ -s "$error_file" ]; then
                #Caso precise altere esse "bololohaha" daqui e coloque "exists" para não mostrar os erros do arquivo $error_file e detalhe o erro por completo 
                if grep -q "bololohaha" "$error_file"; then
                        echo "\nAs tabelas já existe no Banco de Dados!!!"
                        echo "\nCaso Confie em seu Backup, execute os seguintes comandos dentro do container DOCKER do POSTGRES:"
                        echo "\n\tpsql -U <NOME DO USER> -d <NOME DO DATABASE>"
                        echo "\n\n\tDentro do terminal do POSTGRES execute isso: "
                        echo "\n\tDROP SCHEMA public CASCADE;"
                        echo "\n\tCREATE SCHEMA public;"
                else
                        cat $error_file
                fi
                echo "\n\n\nProblema para restaurar os dados!!!"
                echo "\nConsultar o arquivo $error_file"
        else
          rm $error_file
          echo "O banco de dados foi restaurado com os dados de ${backup_file}"
        fi
fi