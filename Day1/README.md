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

## Lab - Find your docker version
```
docker --version
```

## Lab - Listing the docker images present in your local docker registry
```
docker images
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/583ccf04-1a42-405c-ade3-97d03730b088" />

## Lab - Create a container in interactive mode
```
docker run -it --name ubuntu1-jegan --hostname ubuntu1-jegan ubuntu:latest /bin/bash
hostname
hostname -i
ls -l
exit
```

Note
<pre>
docker - is the client tool
run - will create a new container and start it
ubuntu1-jegan - is the name of the container and it must be unique  (optional but as a best practice always provide one)
ubuntu1-jegan - is the hostname of the container (optional but as a best practice always provide one)
ubuntu:latest - is the docker image name from your local docker registry
/bin/bash - is the terminal that will be started inside the container
when you exit from a container that is interactively created, it end up stopping the container
</pre>

## Lab - Creating a container without custom name or hostname
```
# Create new container and start it in interactive mode
docker run -it ubuntu:latest /bin/bash

# Find its hostname assigned by docker server
hostname

# Finds its ip address
hostname -i

# Come out of the container shell, this will also end up terminating the container
exit
```

List only running containers
```
docker ps 
```

List all containers
```
docker ps -a
```

Starting a exited container
```
docker start unruffled_leakey
docker ps

docker exec -it unruffled_leaky /bin/bash
hostname
hostname -i
ls
exit
docker ps
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/43dd5404-5434-49ae-ab24-2406014c5b06" />
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/943cae01-2588-496e-be21-98c661f20f1a" />

## Lab - Deleting a running container

Ideally to delete a container, we must stop it first
```
# List all running containers
docker ps

# Stop one container
docker stop ubuntu1-jegan

# Delete container
docker rm ubuntu1-jegan

# List all running containers
docker ps 
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/f660418b-41f1-40aa-938c-b022f2a5a28f" />

## Lab - Downloading image from Docker Hub Remote Registry to Local Docker Registry
```
docker pull mysql:latest
docker images
```
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/cc609fad-563b-4a31-94c3-bd51149d3a21" />
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/21796aa5-3403-45ea-b814-dbb158947750" />


## Lab - Find more details about a docker image
```
docker inspect image mysql:latest
```

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/fc6f705d-38a1-4324-ba55-a50822401ab3" />
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/983c018f-a2dd-42fd-bd51-d61ce139420f" />

## Lab - Creating a container in interactive(foreground) mode and coming out of container shell without stopping it
```
docker run -it --name ubuntu1-jegan --hostname ubuntu1-jegan ubuntu:latest /bin/bash
hostname
hostname -i
```

Let's say, you wish to come out of the ubuntu1-jegan container shell without stopping it
```
Press Ctrl+P followed by Ctrl+Q
```

Now check if the container is still running
```
docker ps
```

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/bc05e678-b047-4dc6-8c60-c0939b10fdeb" />

## Lab - Creating a custom docker image
Create a sub-folder under your home directory

Create a file named Dockerfile, place this file in a sub-folder
<pre>
FROM ubuntu:latest

RUN apt update && apt install -y vim tree default-jdk iputils-ping net-tools
</pre>

Build your custom docker image
```
mkdir ~/CustomDockerImage
cd ~/CustomDockerImage
touch Dockerfile
docker build -t jegan/ubuntu:1.0 .
docker images | grep jegan
```

Create a container using your custom docker image
```
docker run -dit --name c1-jegan --hostname c1-jegan jegan/ubuntu:1.0 /bin/bash
docker ps
docker exec -it c1-jegan /bin/bash
ifconfig
tree
vim
javac -version
java -version
exit
```

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/4acd2998-2c77-4327-b0c7-5f23a297b019" />
<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/91f54603-5fc0-4519-9d8a-e9cb05470739" />
