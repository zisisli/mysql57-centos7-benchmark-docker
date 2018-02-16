#!/bin/sh

echo "drop table if exists sbtest;" | ${MYSQL_PREFIX}/bin/mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -h 127.0.0.1 ${MYSQL_DATABASE}

sysbench \
  --test=oltp \
  --oltp-table-size=20000 \
  --mysql-user=${MYSQL_USER} \
  --db-driver=mysql \
  --mysql-password=${MYSQL_PASSWORD} \
  --mysql-db=${MYSQL_DATABASE} \
  --mysql-host=127.0.0.1 \
  prepare

sysbench \
  --test=oltp \
  --oltp-table-size=20000 \
  --mysql-user=${MYSQL_USER} \
  --db-driver=mysql \
  --mysql-password=${MYSQL_PASSWORD} \
  --mysql-db=${MYSQL_DATABASE} \
  --mysql-host=127.0.0.1 \
  run

