# Day 4

## Lab - Statefulset
<pre>
- StatefulSet is used to deploy stateful applications
- Scaling up/down a Stateless application(Deployment) is very straight-forward, as the
  pods in the deployment are independent of each other
- Scaling up/down a Stateful application(StatefulSet) is very complex, as those applications involves creating
  a cluster of application(db server container instances) that synchronizes data from master to slave instances
- StatefulSet doesn't support any inbuilt mechanism for synchronizing data, hence it must be taken care by us
</pre>

## Info - Openshift S2I
<pre>
- In Kubernetes, we can only deploy application using container images
- In Openshift, we can deploy applicaiton using container images and from github(or any other version control) url i.e from source code
- This feature in Openshift is called S2I ( Source to Image )
- Openshift supports many different types of strategies
  1. Docker 
  2. Source
  3. Custom
  4. Pipeline(Jenkins/TekTon)
  5. Binary(S2I Binary)
</pre>

## Lab - Deploying our custom spring-boot appliction into Openshift using S2I docker strategy
```
oc new-app --name=hello-microservice https://github.com/tektutor/openshift-june-2026.git --context-dir=Day2/simple-springboot-microservice --strategy=docker

oc expose svc/hello-microservice

oc logs -f bc/hello-microservice

oc get svc,route

curl --insecure http://hello-microservice-jegan.apps.ocp4.palmeto.org
```

## Lab - Horizontal Pod Auto-scaling based on CPU Utilization
```
oc delete project jegan
oc new-project jegan

cd ~
git clone https://github.com/tektutor/openshift-june-2026.git
cd openshift-june-2026
cd Day4/auto-scaling
oc create -f hello-deploy.yml --save-config=true
oc get pods
oc create -f hello-hpa.yml --save-config

oc expose deploy/nginx --port=8080
oc expose svc/nginx
oc get route
```

We need to stree the pod with more traffic
```
ab -k -n 200000 -c 1000 https://nginx-jegan.apps.ocp4.palmeto.org/
```

## Lab - Preferred Node Affinity
```
cd ~/openshift-june-2026
git pull
cd Day4/node-affinity
cat preferred-node-affinity.yml
oc delete project jegan
oc new-project jegan

# Scenario - No nodes has disk=ssd label
oc label node worker03.ocp4.palmeto.org disk=ssd
oc get pods -o wide
oc delete -f preferred-node-affinity.yml
oc apply -f preferred-node-affinity.yml
oc get pods -o wide
oc label node worker03.ocp4.palmeto.org disk-
oc get nodes --show-labels
oc get pods -o wide
oc delete -f preferred-node-affinity.yml

# Scenario - node matches the criteria
oc apply -f required-node-affinity.yml
oc get pods -o wide
oc label node worker03.ocp4.palmeto.org disk=ssd
oc get pods -o wide
```

## Lab - Securing your application using https url (edge route )
```
oc delete project jegan
oc new-project jeganSecuring applications in RedHat OpenShift
oc create deploy nginx --image=image-registry.openshift-image-registry.svc:5000/openshift/bitnami-nginx:1.28 --replicas=3
oc get deploy,pods
oc expose deploy/nginx --port=8080

openssl version
# Let's generate a private key
openssl genrsa -out key.key

# Let's create a public key using the private key for your organization domain
openssl req -new -key key.key -out csr.csr -subj="/CN=nginx-jegan.apps.ocp4.palmeto.org"

# Sign the public key using the private key and generate certificate(.crt)
openssl x509 -req -in csr.csr -signkey key.key -out crt.crt

oc create route edge --service nginx --hostname nginx-jegan.apps.ocp4.palmeto.org --key key.key --cert crt.crt

oc get route
curl -k https://nginx-jegan.apps.ocp4.palmeto.org
```

## Lab - Ingress
<pre>
- Ingress is a Kubernetes feature which is also supported in Openshift
- Ingress provides a public url to expose multiple services using certain rules
  like path as prefix
- Unlike OpenShift Route which generally forwards the request to only one Service,
  Ingress forwards the call to multiple services based on rules
- Ingress is a set of forwarding rules
- Ingress is not a service
- Ingress Controller running in Openshift cluster, keeps looking for Ingress rules
  written under any project namespace
- Whenever, Ingress Controller detects a new Ingress, or an existing Ingress rule got updated or deleted 
  it gets notified
- Ingress Controller retrieves the rules from Ingress and it configures the Load Balancer so the
  Ingress rules will start working
- For an Ingress to work in Kubernetes/Rancher/Openshift, 3 Components are required
  1. Ingress ( Rules )
  2. Ingress Controller
     - Nginx Ingress Controller
     - HAProxy Ingress Controller
     - Traefik Ingress Controller
  3. Load Balancer
     - Nginx Load Balancer
     - HAProxy Load Balancer
     - Traefik Load Balancer
</pre>

Let's proceed with the hands-on exercise
```
cd ~/openshift-june-2026
git pull
cd Day4/ingress
oc apply -f hello-deploy.yml
oc apply -f nginx-deploy.yml

oc apply -f hello-svc.yml
oc apply -f nginx-svc.yml

oc apply -f ingress.yml

oc get pods -o wide -l app=hello
oc get pods -o wide -l app=nginx

oc get svc

oc describe svc/hello
oc describe svc/nginx

oc get ingress
oc describe ingress/tektutor

curl http://tektutor.apps.ocp4.palmeto.org/nginx
curl http://tektutor.apps.ocp4.palmeto.org/hello
```
