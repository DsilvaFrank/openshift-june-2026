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

## Lab - Deploying our custom spring-boot appliction into Openshift using S2I docker strategy
```
oc new-app --name=hello-microservice https://github.com/tektutor/openshift-june-2026.git --context-dir=Day2/simple-springboot-microservice --strategy=docker

oc expose svc/hello-microservice

oc logs -f bc/hello-microservice

oc get svc,route

curl --insecure http://hello-microservice-jegan.apps.ocp4.palmeto.org
```
