# Day 3

## Lab - Declaratively deploy nginx using yaml file
```
oc project jegan
oc delete deploy/nginx

oc create deploy nginx --image=image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.26 --replicas=3 -o yaml --dry-run=client

oc create deploy nginx --image=image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.26 --replicas=3 -o yaml --dry-run=client > nginx-deploy.yml

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

## Info - Persistent Volume (PV)
<pre>
- is the external storage Pods can use to store data externally
- Persistent Volume can be supported by NFS, AWS S3, etc.,
- PV can be provisioned manually by System Administrators, or can be provisioned dynamically using Storage Class
- Storage Class can be created using yaml manifest file
</pre>

## Info - Persistent Volume Claim (PVC)
<pre>
- is the storage request from a Pod
- in other words, any Pod that needs external storage, should ask the cluster for external storage
  by definining PVC
  - how much storage is required
  - what type of access is required, ReadWriteOnce, ReadWriteMany,etc.,
  - StorageClass( Optional ) - a way PV can be dynamically provisioned on demand from NFS, S3 buckets, etc.,
  - Label constraints ( optional )
- If the Storage Controller, finds a matching PV that meets all the constraints of PVC, then it will let your Pod
  claim the storage and use it
</pre>
