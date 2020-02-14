Performance tests mysql57 on docker

# Deploy
## oc new-app
```
oc new-app -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db  https://github.com/zisisli/mysql57-centos7-benchmark-docker.git
```
## local build
```
$ oc new-project mysql-perftest
$ oc new-build --name perftest --binary --strategy docker
$ oc start-build perftest --from-dir=.
// wait for build
$ oc new-app perftest MYSQL_USER=user MYSQL_PASSWORD=pass MYSQL_DATABASE=db
```

# set persistent volumes
(optional)
```
oc set volume dc/mysql57-centos7-benchmark-docker --add --mount-path=/var/lib/mysql --name=mysql-storage
oc set volume dc/mysql57-centos7-benchmark-docker --add --name=mysql-storage -t pvc --claim-size=5G --overwrite
```


# Test

## script
```
$ oc get pods
$ oc rsh <POD>
$ sh-4.2$ /scripts/00-mysql-bench.sh
...
```

## manually
Execute tests on docker container:
```
echo "drop table sbtest;" | mysql -u user -ppass -h 127.0.0.1 db
sysbench --test=oltp --oltp-table-size=20000 --mysql-user=user --db-driver=mysql --mysql-password=pass   --mysql-db=db --mysql-host=127.0.0.1 prepare
sysbench --test=oltp --oltp-table-size=20000 --mysql-user=user --db-driver=mysql --mysql-password=pass   --mysql-db=db --mysql-host=127.0.0.1 run
```

# Sample results
## FreeNAS storage
```
mysql: [Warning] Using a password on the command line interface can be insecure.
sysbench 0.4.12.10:  multi-threaded system evaluation benchmark

Creating table 'sbtest'...
Creating 20000 records in table 'sbtest'...
sysbench 0.4.12.10:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 1
Random number generator seed is 0 and will be ignored


Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "BEGIN" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Using 1 test tables
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140000
        write:                           50000
        other:                           20000
        total:                           210000
    transactions:                        10000  (185.06 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190000 (3516.23 per sec.)
    other operations:                    20000  (370.13 per sec.)

General statistics:
    total time:                          54.0351s
    total number of events:              10000
    total time taken by event execution: 53.9484
    response time:
         min:                                  3.89ms
         avg:                                  5.39ms
         max:                                162.77ms
         approx.  95 percentile:               7.21ms

Threads fairness:
    events (avg/stddev):           10000.0000/0.00
    execution time (avg/stddev):   53.9484/0.00

```

## local hdd
```
Doing OLTP test.
Running mixed OLTP test
Using Special distribution (12 iterations,  1 pct of values are returned in 75 pct cases)
Using "BEGIN" for starting transactions
Using auto_inc on the id column
Maximum number of requests for OLTP test is limited to 10000
Using 1 test tables
Threads started!
Done.

OLTP test statistics:
    queries performed:
        read:                            140000
        write:                           50000
        other:                           20000
        total:                           210000
    transactions:                        10000  (234.14 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 190000 (4448.65 per sec.)
    other operations:                    20000  (468.28 per sec.)

General statistics:
    total time:                          42.7096s
    total number of events:              10000
    total time taken by event execution: 42.6335
    response time:
         min:                                  2.71ms
         avg:                                  4.26ms
         max:                                331.61ms
         approx.  95 percentile:               5.89ms

Threads fairness:
    events (avg/stddev):           10000.0000/0.00
    execution time (avg/stddev):   42.6335/0.00
```
