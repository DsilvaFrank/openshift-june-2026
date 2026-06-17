#!/bin/bash

echo "\nRemoving WordPress Route and Service..."
oc delete -f wordpress-route.yml
oc delete -f wordpress-svc.yml

echo "\nRemoving WordPress StatefulSet..."
oc delete -f wordpress-statefulset.yml

echo "\nWaiting for WordPress Pods to terminate..."
oc wait --for=delete pod -l app=wordpress --timeout=120s

echo "\nCleaning up WordPress NFS data..."
# Spins up a temporary busybox Pod that mounts the WordPress PVC
# and deletes everything inside it. Waits for the Pod to reach
# Succeeded phase (command exited 0) before proceeding.
oc apply -f cleanup-wordpress.yml
oc wait --for=jsonpath='{.status.phase}'=Succeeded pod/wordpress-cleanup --timeout=60s
echo "WordPress data cleaned."
oc delete pod/wordpress-cleanup --ignore-not-found

echo "\nDeleting WordPress PVC and PV..."
oc delete -f wordpress-pvc.yml
oc delete -f wordpress-pv.yml

echo "\nRemoving ProxySQL..."
oc delete -f proxysql-deploy.yml
oc delete -f proxysql-cm.yml

echo "\nRemoving MySQL StatefulSet..."
oc delete -f mysql-statefulset.yml

echo "\nWaiting for MySQL Pods to terminate..."
oc wait --for=delete pod -l app=mysql --timeout=120s

echo "\nCleaning up MySQL NFS data..."
oc apply -f cleanup-mysql.yml
oc wait --for=jsonpath='{.status.phase}'=Succeeded pod/mysql-cleanup --timeout=60s
echo "MySQL data cleaned."
oc delete pod/mysql-cleanup --ignore-not-found

echo "\nDeleting MySQL PVC, PV and Service..."
oc delete -f mysql-pvc.yml
oc delete -f mysql-pv.yml
oc delete -f mysql-svc.yml

echo "\nRemoving ConfigMap and Secrets..."
oc delete -f wordpress-cm.yml
oc delete -f wordpress-secrets.yml

echo "\nDone. All NFS data cleaned up."
