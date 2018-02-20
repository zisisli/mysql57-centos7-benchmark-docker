Performance tests mysql57 on docker


Execute tests on docker container:
```
echo "drop table sbtest;" | mysql -u user -ppass -h 127.0.0.1 db
sysbench --test=oltp --oltp-table-size=20000 --mysql-user=user --db-driver=mysql --mysql-password=pass   --mysql-db=db --mysql-host=127.0.0.1 prepare
sysbench --test=oltp --oltp-table-size=20000 --mysql-user=user --db-driver=mysql --mysql-password=pass   --mysql-db=db --mysql-host=127.0.0.1 run
```


For OpenShift, adjust deployment config:
```
...
    spec:
      containers:
      - env:
        - name: MYSQL_USER
          value: user
        - name: MYSQL_PASSWORD
          value: pass
        - name: MYSQL_DATABASE
          value: db
...
```
