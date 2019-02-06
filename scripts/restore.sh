#! /bin/bash

#PRESERVAÇÃO DO FICHEIRO DE CONFIGURACAO DO POSTGRESQL
cp tpcc-db/postgresql.conf ~/

# REMOÇÃO DA BASE DE DADOS ANTERIOR
rm -r tpcc-db

# INICIALIZAÇÃO DA NOVA BD
initdb -D tpcc-db

echo '========== CHECKING IF POSTGRES PORT IS USED =========='
sudo netstat -anp | grep ':5432 '
echo '======================================================='

# POSTGRES EM BG
tmux new -d -s postgres

tmux send-keys -t postgres.0 "postgres -D tpcc-db -k." ENTER

echo '========== CREATEDB INITIALIZING IN ==================='
for i in {5..1}
do
	echo "$i"
	sleep 1
done

createdb -h localhost tpcc-db

# RESTORE COM RECURSO AO FICHEIRO tpcc.dump
echo '========== RESTORE INTIALIZED ========================='
time pg_restore -h localhost -d tpcc-db -Fc -j 8 tpcc.dump

#PRESERVACAO DO FICHEIRO DE CONFIGURACAO DO POSTGRESQL

mv ~/postgresql.conf ~/tpcc-db/

# TERMINAR A SESSÃO DO TMUX QUE ESTÁ A CORRER O POSTGRES
tmux send-keys -t postgres "C-c"
tmux kill-session -t postgres


