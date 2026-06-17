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
echo "\nNFS subfolders created automatically under /var/nfs/jegan/mysql/:"
echo "  mysql-0/   <- mysql-0 Pod data directory"
echo "  mysql-1/   <- mysql-1 Pod data directory"
echo "  mysql-2/   <- mysql-2 Pod data directory"
echo "\nUseful commands:"
echo "  Scale WordPress:  oc scale statefulset wordpress --replicas=3"
echo "  Scale MySQL:      oc scale statefulset mysql --replicas=3"
echo "  Check pods:       oc get pods"
echo "  Verify subPaths:  ls /var/nfs/jegan/mysql/   (run on NFS server)"
