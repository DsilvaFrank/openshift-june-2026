# Day 4

## Lab - Statefulset
<pre>
- StatefulSet is used to deploy stateful applications
- Scaling up/down 
</pre>

## Lab - Deploying our custom spring-boot appliction into Openshift using S2I docker strategy
```
oc new-app --name=hello-microservice https://github.com/tektutor/openshift-june-2026.git --context-dir=Day2/simple-springboot-microservice --strategy=docker

oc expose svc/hello-microservice

oc logs -f bc/hello-microservice

oc get svc,route
```
