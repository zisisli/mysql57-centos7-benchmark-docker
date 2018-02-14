FROM centos/mysql-57-centos7

USER root
RUN  yum install -y epel-release
RUN  yum install -y sysbench

RUN  rm -rf /etc/my.cnf.d/*
RUN  /usr/libexec/container-setup && rpm-file-permissions

USER 27
ENTRYPOINT ["container-entrypoint"]
CMD ["run-mysqld"]
