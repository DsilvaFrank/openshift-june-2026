# Day 3

## Info - Pod Network
<pre>
- At the time of installing Openshift, we can choose the network fabric like Calico, Weave, Flannel, etc
- Depending on which fabric we have installed in Kubernetes/Openshift, it would allocate a range of IP Addresses for each node
- As we know, each node in Openshift by default supports upto 250 Pods 
- hence, in case 10.20.0.0/16 is IP range we choose or the network fabric chose, it will be divided into Pod subnets
  For example
  - For Master 1 ( 10.20.1.0/24 )
  - For Master 2 ( 10.20.2.0/24 )
  - For Master 3 ( 10.20.3.0/24 )
  - For Worker 1 ( 10.20.10.0/24 )
  - For Worker 2 ( 10.20.11.0/24 )
  - For Worker 3 ( 10.20.12.0/24 )
</pre>

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
