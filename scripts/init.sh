#! /bin/bash

initdb -D tpcc-db
sleep 5
postgres -D tpcc-db -k. &
sleep 5
createdb -h localhost tpcc-db
cd tpc-c-0.1-SNAPSHOT/etc/sql/postgresql/
for i in createtable.sql createindex.sql sequence.sql *0*; do cat $i | psql -h localhost tpcc-db; done
cd ../../../
sudo ./load.sh > /dev/null
