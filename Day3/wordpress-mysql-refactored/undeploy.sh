#!/bin/bash

echo "\nRemoving WordPress Route and Service..."
oc delete -f wordpress-route.yml
oc delete -f wordpress-svc.yml

echo "\nCleaning up WordPress NFS data (while Pod still has volume mounted)..."
# Clean data BEFORE deleting the StatefulSet.
# The wordpress-0 Pod already has the PVC mounted with the right permissions,
# so this is more reliable than a separate cleanup Pod.
oc exec wordpress-0 -- sh -c "rm -rf /bitnami/wordpress/* /bitnami/wordpress/.[!.]*" \
  && echo "WordPress data cleaned." \
  || echo "Warning: WordPress data cleanup failed - clean NFS manually."

echo "\nRemoving WordPress StatefulSet..."
oc delete -f wordpress-statefulset.yml

echo "\nWaiting for WordPress Pods to terminate..."
oc wait --for=delete pod -l app=wordpress --timeout=120s

echo "\nDeleting WordPress PVC and PV..."
oc delete -f wordpress-pvc.yml
oc delete -f wordpress-pv.yml

echo "\nRemoving ProxySQL..."
oc delete -f proxysql-deploy.yml
oc delete -f proxysql-cm.yml

echo "\nCleaning up MySQL NFS data (while Pods still have volumes mounted)..."
# Clean each MySQL Pod's subfolder while it still has the volume mounted.
for pod in mysql-0 mysql-1 mysql-2; do
  echo "  Cleaning $pod..."
  oc exec $pod -- sh -c "rm -rf /bitnami/mariadb/data/* /bitnami/mariadb/data/.[!.]*" \
    && echo "  $pod data cleaned." \
    || echo "  Warning: $pod cleanup failed - clean NFS manually."
done

echo "\nRemoving MySQL StatefulSet..."
oc delete -f mysql-statefulset.yml

echo "\nWaiting for MySQL Pods to terminate..."
oc wait --for=delete pod -l app=mysql --timeout=120s

echo "\nDeleting MySQL PVC, PV and Service..."
oc delete -f mysql-pvc.yml
oc delete -f mysql-pv.yml
oc delete -f mysql-svc.yml

echo "\nRemoving ConfigMap and Secrets..."
oc delete -f wordpress-cm.yml
oc delete -f wordpress-secrets.yml

echo "\nDone. All data cleaned up."
