#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '############ About to run setup_mariadb_server.sh script #################'
echo '##########################################################################'

yum group install -y mariadb
yum group install -y mariadb-client

cp /etc/my.cnf /etc/my.cnf-orig

# https://stackoverflow.com/a/15559399  
sed -i '/fedoraproject/a bind-address=10.2.5.10' /etc/my.cnf


systemctl start mariadb
systemctl enable mariadb

mysql_secure_installation <<EOF

rootpassword
Y
Y
Y
Y
Y
EOF

systemctl restart mariadb

firewall-cmd --permanent --add-service=mysql
systemctl restart firewalld



exit 0