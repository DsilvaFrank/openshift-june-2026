# Day 2

## Lab - Check if you are able to access Openshift
```
oc version
kubectl version

oc get nodes
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/35603468-5e51-46d6-9071-e1b6f0b9899d" />


## Info - Container Orchestration Platform Overview
<pre>
- In real world applications, no one uses plain docker/podman/containerd containers
- Container platforms provides the below features out of the box
  - in built application monitoring and healing them
  - in built load balancing 
  - on demand, depending user traffic to an application we can scale up/down the application instances
  - High Availability (HA)
  - they also provide a way to control access to your applicaiton
    - only to internal users/applications
    - expose your application for external use
- examples
  - Docker SWARM
  - Kubernetes
  - Rancher
  - Red Hat Openshift
  - AWS eks
  - Azure aks
  - AWS ROSA
  - Azure ARO
</pre>

## Info - Docker SWARM
<pre>
- this is native Container Orchestration Platform developed by Docker Inc
- it only supported Docker Containerized applications
- it is free but supports only docker no other container engine or runtime
- it is very easy to setup, learn
- it is not production grade
- ideal for learning, proof of concept, QA/Dev environment
- applications will be deployed as Docker container
- every container will get a IP
</pre>

## Info - Kubernetes (k8s)
<pre>
- this is a container orchestration plaform developed by Google in Golang
- this was originally called borg inside Google
- borg was used by Google many years in mulitple complex projects internally before they decided to make it opensource
- borg was refactored as Kubernetes improving many things
- Kubernetes is a better borg
- it is opensource and free
- it supports all container engines and runtimes
- initially, they supported Docker Engine as the default containerization tool
- applications will be deployed as Pod
- Pod - a group of related containers
- all containers in a single Pod will one get a single IP
- Pod is the smallest unit that can be deployed in Kubernetes
- it is a command-line tool, there is no production grade webconsole
- this is actually used in production by many companies
- Kubernetes provides a way to extend Kubernetes API and features by defining your own Custom Resources
  and Custom Resource Definitions
- To manage each type of Resource, there will one type of Controller
- The default resources supported by Kubernetes are
  - Pod
  - ReplicaSet
  - Deployment
  - StatefulSet
  - DaemonSet
  - Job
  - CronJob
  - Service
- there are two types of machines involved in the Kubernetes Cluster
  1. Master Node 
     - this machine runs components that provides the Container Orchestration Features for the cluster
     - by default, user application will not run here ( however, you can override/configure to allow deploying user applications )
     - this is where Control Plane Components will be running
       1. API Server
       2. etcd key/value database
       3. Scheduler
       4. Controller Manager(s)
          - this components hosts many Controllers
  2. Worker Node
     - this machine is where user application will be deployed
 - node are machines with dedicated linux OS, it can be Physical Server or Virtual Machine on your local datacenter, or an ec2 in public cloud
 - we can install any Linux OS distribution into the nodes
- Kubernetes allows to extend Kubernetes features ( K8s API)
  - you can add your custom resource, custom controller, Operators, etc
  - using thes building block one can add any new feature on top of Kubernetes
</pre>

## Info - Kubernetes High-Level Architecture
![Kubernetes](KubernetesArchitecture2.png)

## Info - Red Hat Openshift High-Level Architecture
![Openshift](openshiftArchitecture.png)
![Openshift](master-node.png)

## Info - Red Hat Openshift
<pre>
- is Red Hat's distribution of Kubernetes 
- it is developed on top of opensource Kubernetes, but this is commercial 
- it is a superset of Kubernetes with many additional features
- Using the K8s basic building block, Red Hat has added many additional useful features on top of K8s
- Openshift specific features ( not supported in K8s)
  - Route
  - DeploymentConfig
  - Project
  - Build
  - BuildConfig
  - Webconsole
  - User Management
  - Internal Container Image Registry ( comes out of the box )
</pre>

## Lab - Listing all the nodes in the Openshift cluster
```
oc get nodes
kubectl get nodes
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/de0b33c6-4f77-4ef4-b967-5d2bee04a694" />

## Info - Stateless applications
<pre>
- each call to a Pod will be treated as an independent invocation
- the Pod will have no clue which user called last time, it only know about the current session
- this kind of Pods can be replaced and repaired easily
- because for the end user it doesn't matter whether Pod1 is server them or Pod10 is serving them
- for this type of applications, you have something called Deployment in Kubernetes and OpenShift
- Deployment is a in-built Resource supported by Kubernetes and Openshift
</pre>

## Info - API Server
<pre>
- API is one of the Control Plane components that runs in master nodes
- API Server is a collection of many REST APIs for every feature supported by Openshift
- API Server is the only component that is allowed to read/write into etcd key/value datastore
- API Server sends events each time the etcd database is updated
  - New Pod created
  - Existing Pod modified
  - Existing Pod deleted
  - New Deployment created
  - Existing Deployment modified
  - Existing Deployment deleted
</pre>  

## Info - Deployment Controller
<pre>
- Controller is a special type of Pod that runs in the Kubernetes/Openshift cluster
- You can imagine this application as infinite loop
- controllers in general - are the ones who does the actual work
- Deployment Controller supports rolling update
  - used for upgrading your application from one version to the other ( without downtime )
- Deployment Controller depends on ReplicaSet Controller for Scale up/down
- For stateless application, 2 Controllers are involved
  1. Deployment Controller
     - Deployment Controller manages a Resource type called Deployment
     - Deployment is a collection of one or more ReplicaSet
     - ReplicaSet is a collection of one or more Pods
     - Pods is a logical group of one or more Containers
  2. ReplicaSet Controller
     - this ensure if user asked to run 3 Pods instances of their application, those 3 are always running
     - responsible scale up/down
     - ReplicaSet Controller manages a Resource type called ReplicaSet
</pre>

## Lab - Let's create our first project
Replace 'jegan' with your name because the project name must be unique within the Openshift Cluster.

Create a openshift project
```
oc new-project jegan
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/725632fa-54d4-41f7-88e6-6d4b749acd3b" />

Listing all the projects
```
oc get projects
oc get project
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/c068226f-0700-442e-9410-79c60f96790e" />

Switching between projects
```
oc project jegan
oc project default
```

Finding the currently active project
```
oc project
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/46750e69-2407-402c-a4d3-bddd6f99fc37" />


Deleting a project that you created
```
oc delete project jegan
```

## Lab - List the nginx images present in your Openshift Cluster
```
oc get imagestreams -n openshift

oc project openshift
oc get imagestreams
oc get imagestream
oc get is | grep nginx
```

## Lab - Deploy your first stateless application into Openshift
```
oc project jegan

# Server 1 (192.168.10.200)
oc create deploy nginx --image=image-registry.openshift-image-registry.svc:5000/openshift/nginx:1.26 --replicas=3

# Server 2 (192.168.10.201)
oc create deploy nginx --image=image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.26 --replicas=3
```

List the deployment under your project
```
oc get deployments
oc get deployment
oc get deploy
```

List the replicasets under your project
```
oc get replicasets
oc get replicaset
oc get rs
```

List the pods
```
oc get pods
oc get pod
oc get po
oc get pods -o wide
```

Deleting deployment
Note
<pre>
- When deployment is deleted, it will automatically delete all the replicasets and pods under them
- once deleted, there is no way to recover them, hence think twice before deleting your deployment
</pre>
```
oc delete deploy/nginx
```

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/a11d0d86-eab1-4da0-8da2-3194966f5ca0" />
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/9f98aa60-ae19-4577-aa1c-7c8f5cf2894d" />

Listing multiple resources with a single command
```
oc get all
oc get deploy,rs,po
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/7e39d931-e361-40f3-a3b6-bd837eac80b4" />


Note
<pre>
- Repairing stateless applications are relatively easy compared to stateful applications
- each Pod in a Deployment is dependent of other Pods
- In case, a Pod is found defective in a Deployment, it can be easily replaced with another new Pod on the same node or on another node
  by the respective Controller
</pre>


## Lab - Finding more details about deployment
```
oc project jegan
oc get deploy
oc describe deploy/nginx
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/aacfdae2-a575-4d24-a50e-5e9c644ec4c7" />

## Lab - Finding more details about replicaset
```
oc project jegan
oc get rs
oc describe rs/nginx-bb9bcb898
```


## Lab - Find more details about a pod
```
oc project jegan
oc get pods
oc describe pod/nginx-bb9bcb898-
```

## Lab - Port forward - used for quick debugging
```
oc project jegan
oc get pods
# Terminal 1 (Ctrl+C to stop once curl command responds)
oc port-forward pod/nginx-bb9bcb898-bbx2g 9090:8080

# Terminal 2
curl http://localhost:9090
```

## Info - Services
<pre>
- Kubernetes/Openshift supports 3 types of services
  1. ClusterIP ( Internal Service )
  2. NodePort ( External Service )
  3. LoadBalancer ( External Service )
- Kubernetes/Openshift service represents a group of load-balanced pods from a single application
</pre>

## Info - ClusterIP Internal Service
<pre>
- this type of internal service is used by databases 
- any application tha runs in the same cluster can access the respective pods via ClusterIP 
- ClusterIP Service when created, it will be assigned an unique and IP Address (ClusterIP)
</pre>

## Lab - Creating an internal service for nginx deployment
```
oc project jegan
oc get deploy
oc expose deploy/nginx --type=ClusterIP --port=8080
oc get services
oc get service
oc get svc
oc describe svc/nginx
```

## Lab - Creating an internal service for nginx deployment
```
oc project jegan
oc get deploy
oc expose deploy/nginx --type=ClusterIP --port=8080
oc get services
oc get service
oc get svc
oc describe svc/nginx

# Access the ClusterIP service
oc create deploy hello --image=docker.io/tektutor/spring-ms:1.0
oc rsh deploy/hello
curl http://nginx:8080
exit
```

## Lab - Creating an external service for nginx deployment
```
oc project jegan
oc get deploy
oc delete svc/nginx
oc expose deploy/nginx --type=NodePort --port=8080
oc get services
oc get service
oc get svc
oc describe svc/nginx

# Access the nodeport service
curl http://192.168.100.11:31269 # Master 1
curl http://192.168.100.12:31269 # Master 2
curl http://192.168.100.13:31269 # Master 3

curl http://192.168.100.21:31269 # Worker 1
curl http://192.168.100.22:31269 # Worker 2
curl http://192.168.100.23:31269 # Worker 3
```

## Lab - Creating an external LoadBalancer service for nginx deployment
```
oc project jegan
oc get deploy
oc delete svc/nginx
oc expose deploy/nginx --type=LoadBalancer --port=8080
oc get services
oc get service
oc get svc
oc describe svc/nginx

# Access the loadbalancer service
curl http://<external-ip-of-loadbalancer-service>:8080
curl http://192.168.100.50:8080
```


