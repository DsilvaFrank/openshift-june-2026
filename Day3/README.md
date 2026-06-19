# Day 3

## Info - You can find Red Hat Base images here
<pre>
https://catalog.redhat.com/en/software/containers/explore
</pre>

## Info - You can find other Red Hat Openshift compatible images here
<pre>
https://catalog.redhat.com/en/search?searchType=Containers
</pre>  

## Info - What happens internally in Openshift when we deploy an application
```
oc create deploy nginx --image=docker.io/bitnamilegay/nginx:latest --replicas=3
```

Note
<pre>
- oc client tool makes a REST call to API Server requesting the API Server to create a deployment
- Once API Server receives the request from oc client, it creates a Deployment database entry in etcd database
- API Server then sends broadcasting event saying new Deployment created along with deployment details
- Deployment Controller receives this event, it then makes a REST call to API Server requesting it to create a ReplicaSet for the nginx deployment
- API Server creates a ReplicaSet db entry(new record) in the etcd database
- API Server sends a broadcast event saying new ReplicaSet created
- ReplicaSet Controller receives the event, it then makes a REST call to API Server requesting it to create 3 Pods
- API Server create 3 Pod records in the etcd database
- API Server sends broadcast event for each new Pod created in the etcd database
- Scheduler receives the event, it then identifies a healthy node where the new Pod can be deployed
- Scheduler makes a REST call to API Server to send it scheduling recommendataion. This will be done for each Pod.
- API Server receives the scheduling recommendations from Scheduler, it then retrieves the Pod record from etcd and updates it status as Scheduled to so and so node
- API Server sends a broadcasting event saying Pod1 scheduled to Worker01 node, this happens for each Pod.
- Kubelet Container Agent that runs on Worker01 node receives the event, it then pull the container image, creates and starts the container on Worker01
- Kubelet monitors the status of the Container created for Pod1, and it periodically updates the status back to API Server in a heart-beat fashion
- API Server receives these updates, retrieves the Pod database entry from etcd and updates the Pod status
</pre>
![Openshift](openshift-internals.png)

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
