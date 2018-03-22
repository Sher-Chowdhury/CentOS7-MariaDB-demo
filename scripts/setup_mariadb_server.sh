#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '############ About to run setup_mariadb_server.sh script #################'
echo '##########################################################################'

yum group install -y mariadb
yum group install -y mariadb-client

exit 0