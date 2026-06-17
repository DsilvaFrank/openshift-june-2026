#!/bin/bash

echo "\nDeploying ConfigMap and Secrets..."
oc apply -f wordpress-cm.yml
oc apply -f wordpress-secrets.yml

echo "\nDeploying MySQL..."
oc apply -f mysql-pv.yml
oc apply -f mysql-pvc.yml
oc apply -f mysql-svc.yml
oc apply -f mysql-statefulset.yml

echo "\nWaiting for mysql-0 to be Ready..."
oc wait pod/mysql-0 --for=condition=Ready --timeout=180s

echo "\nCreating replication and monitor users on mysql-0..."
# The Bitnami MariaDB image does not reliably create MARIADB_REPLICATION_USER
# via env vars in all versions. Creating the users explicitly on mysql-0 after
# first boot guarantees they exist before replicas try to connect.
#
# replicator: used by mysql-1, mysql-2 to stream the binary log from mysql-0.
# monitor:    used by ProxySQL to health-check all three MySQL backends.
#             ProxySQL defaults to monitor/monitor when not explicitly configured.
oc exec mysql-0 -- mariadb -uroot -proot@123 <<SQL
CREATE USER IF NOT EXISTS 'replicator'@'%' IDENTIFIED BY 'repl@123';
GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';

CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED BY 'monitor';
GRANT SELECT, REPLICATION CLIENT ON *.* TO 'monitor'@'%';

FLUSH PRIVILEGES;
SHOW GRANTS FOR 'replicator'@'%';
SHOW GRANTS FOR 'monitor'@'%';
SQL

echo "\nDeploying ProxySQL..."
oc apply -f proxysql-cm.yml
oc apply -f proxysql-deploy.yml

echo "\nWaiting for ProxySQL to be Ready..."
oc wait deployment/proxysql --for=condition=Available --timeout=60s

echo "\nDeploying WordPress..."
oc apply -f wordpress-pv.yml
oc apply -f wordpress-pvc.yml
oc apply -f wordpress-statefulset.yml
oc apply -f wordpress-svc.yml
oc apply -f wordpress-route.yml

echo "\nDone."
echo "\nUseful commands:"
echo "  Scale WordPress:  oc scale statefulset wordpress --replicas=3"
echo "  Scale MySQL:      oc scale statefulset mysql --replicas=3"
echo "  Check pods:       oc get pods"
echo "  Check replication: oc exec mysql-1 -- mariadb -uroot -proot@123 -e 'SHOW SLAVE STATUS\G'"
