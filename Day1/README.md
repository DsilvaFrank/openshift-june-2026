# Day 1

## Info - Hypervisor Overview
<pre>
- is nothing but virtualization technology
- two types of hypervisors
  1. Type 1 a.k.a Bare Metal Hypervisor
     - is used in Workstations/Servers
     - can expect near-native performance
     - 3% overhead
     - the OS the runs inside a Virtual Machine is called Guest OS
     - Guest OS can be Windows, Linux or Mac OS
     - there is no Host OS Layer, in case of Type 1 Hypervisor
     - the Guest OS is a fully functional Operating System with its own dedicated OS Kernel
     - each Guest OS, gets its own dedicated hardware resources
       - CPU Cores ( virtual/logical CPU cores )
       - RAM ( Actual )
       - Storage ( Actual )
     - is called heavy-weight virtualization as every VM requires dedicated H/W resources
     - examples
       - Microsoft Hyper-V ( comes with Server grade Windows OS )
       - Linux KVM ( Opensource & Free )
       - VMWare vSphere(vcenter) - Commercial license required
  
  2. Type 2 a.k.a Hosted Hypervisor
     - is used in Desktops/Workstations/Laptops
     - the OS that runs inside a Virtual Machine is called Guest OS 
     - Guest OS can be Windows, Linux or Mac OS
       - each Guest OS, gets its own dedicated hardware resources
       - CPU Cores ( virtual/logical CPU cores )
       - RAM ( Actual )
       - Storage ( Actual )
     - is called heavy-weight virtualization as every VM requires dedicated H/W resources
     - examples
       - VMWare Fusion ( Mac OS-X )
       - VMWare Workstation - Free ( Linux & Windows )
       - Parallels ( Mac OS )
       - Oracle VirtualBox - Free ( Windows, Linux & Mac )
</pre>

## Info - Containerization Overview
<pre>
- it is a light-weight application virtualization technology
- each container represents one application ( or application process in OS )
- container's don't represent an Operating System
- containers will never be able to replace OS or VMs
- generally one process runs per container
- container = application + dependent library + tools
- is a linux technology
- linux kernel supports
  1. Namespace 
     - one container can be isolated from other containers
  2. Control Groups or CGroups
     - we can apply resource quota restrictions on container level
     - we can restrict how much RAM a particular can utilize at the max
     - we can restrict how much storage a particular can utilize at the max
     - we can restrict how much % of CPU can be utilized by a single container
- Container Engine
  - is a high-level user-friendly software that manages containers and images
  - under the hood, container engines depends on Container Runtimes to manage containers and images
  - examples
    - Docker 
    - Podman
- Container Runtime
  - is a low-level software that manages containers and images
  - it is not user-friendly, hence end-users generally don't use this directly
  - examples
    - runC
    - cRun
    - CRI-O
</pre>

## Info - Docker Overview
<pre>
- is developed in Golang by a company called Docker Inc
- Docker follows Client/Server Architecture
- Docker Application Container Engine ( Server )
  - dockerd
- Docker Client
  - docker
- The docker client/server they communicate with each other if installed on the same machine
  using local unix socket
- In case docker client runs on separate machine and server runs on another machine, they communicate using REST API
- in order to manage docker images or docker containers, we as end-users will be issuing command using the docker client
- in order to issue docker commands, one must be part of an user group called docker
- those users who are part of docker user group, they only gain read/write access to the unix socket that is usef by docker client & server
</pre>

## Info - Docker Image
<pre>
- is a blueprint of a container
- Image => An application + with all its dependencies
- it is a JSON file which refers to multiple docker image layers
- in other words, image is further broken down into many image layers
- just like every image has an unique name and id, image layers also has their own unique ID
- the unique ids are 256 bit HASH
- the image layers can be shared by multiple docker images
</pre>

## Info - Docker Container
<pre>
- is a running instance of a Docker Image
- each container gets its own file system ( files and folders )
- each container gets its own unique name and IP address
- each container gets its own Network stack ( OSI - 7 layers )
- each container uses its own namespaces ( 7 types of namespaces )
  - PID namespace
  - network namespace
- every containter gets is own Port range ( 0 - 65535 )
- it is for these reasons, people tend to compare a container with a VM or an Operating System
- technically comparing an OS with container is wrong, but because they have OS/VM and container has some common
  features, people tend make this sort of comparisons
- container will have its own hostname just like VMs/OS
</pre>


