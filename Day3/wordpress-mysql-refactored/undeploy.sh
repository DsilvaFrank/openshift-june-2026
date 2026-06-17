#!/bin/bash

echo "\nRemoving WordPress..."
oc delete -f wordpress-route.yml
oc delete -f wordpress-svc.yml
oc delete -f wordpress-statefulset.yml
oc delete -f wordpress-pvc.yml
oc delete -f wordpress-pv.yml

echo "\nRemoving ProxySQL..."
oc delete -f proxysql-deploy.yml
oc delete -f proxysql-cm.yml

echo "\nRemoving MySQL..."
oc delete -f mysql-statefulset.yml
oc delete -f mysql-svc.yml
# Single PVC - delete it explicitly (no volumeClaimTemplates auto-PVCs here)
oc delete -f mysql-pvc.yml
oc delete -f mysql-pv.yml

echo "\nRemoving ConfigMap and Secrets..."
oc delete -f wordpress-cm.yml
oc delete -f wordpress-secrets.yml

echo "\nNote: NFS subfolders mysql-0/, mysql-1/, mysql-2/ remain on the server."
echo "Delete them manually on the NFS server if needed:"
echo "  rm -rf /var/nfs/jegan/mysql/mysql-0"
echo "  rm -rf /var/nfs/jegan/mysql/mysql-1"
echo "  rm -rf /var/nfs/jegan/mysql/mysql-2"
