FROM centos/mysql-57-centos7

USER root
RUN  yum install -y mariadb-libs
COPY files/sysbench-bin-0.4.12.14 /usr/bin/sysbench
COPY files/00-mysql-bench.sh /scripts/
RUN  chmod 755 /scripts/00-mysql-bench.sh

RUN  rm -rf /etc/my.cnf.d/*
RUN  /usr/libexec/container-setup && rpm-file-permissions

USER 27
ENTRYPOINT ["container-entrypoint"]
CMD ["run-mysqld"]
