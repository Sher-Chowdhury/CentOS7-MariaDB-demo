#!/usr/bin/env bash
# exit 0
set -ex

echo '##########################################################################'
echo '############# About to run setup_mariadb_client.sh script ################'
echo '##########################################################################'


yum group install -y mariadb
yum group install -y mariadb-client


exit 0