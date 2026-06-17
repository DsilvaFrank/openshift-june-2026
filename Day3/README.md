# Day 3

## Lab - Declaratively deploy nginx using yaml file
```
oc project jegan
oc delete deploy/nginx

oc create deploy nginx --image= image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.26 --replicas=3 -o yaml --dry-run=client

oc create deploy nginx --image= image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.26 --replicas=3 -o yaml --dry-run=client > nginx-deploy.yml

oc create -f nginx-deploy.yml --save-config=true
oc get deploy,rs,po
```

## Lab - Declaratively creating a clusterip internal service
```
oc project jegan
oc delete svc/nginx
oc expose deploy/nginx --type=ClusterIP --port=8080 -o yaml --dry-run=client

oc expose deploy/nginx --type=ClusterIP --port=8080 -o yaml --dry-run=client > nginx-clusterip-svc.yml
oc apply -f nginx-clusterip-svc.yml
oc get svc
oc describe svc/nginx
```



## Lab - Declaratively creating a loadbalancer internal service
```
oc project jegan
oc delete svc/nginx
oc expose deploy/nginx --type=LoadBalancer --port=8080 -o yaml --dry-run=client

oc expose deploy/nginx --type=LoadBalancer --port=8080 -o yaml --dry-run=client > nginx-lb-svc.yml
oc apply -f nginx-lb-svc.yml
oc get svc
oc describe svc/nginx
```

## Lab - Declaratively creating a nodeport internal service
```
oc project jegan
oc delete svc/nginx
oc expose deploy/nginx --type=NodePort --port=8080 -o yaml --dry-run=client

oc expose deploy/nginx --type=NodePort --port=8080 -o yaml --dry-run=client > nginx-nodeport-svc.yml
oc apply -f nginx-nodeport-svc.yml
oc get svc
oc describe svc/nginx
```
