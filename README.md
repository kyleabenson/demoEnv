# demoEnv
Quickly setup an Ansible Tower deployment for demo purposes

This demo environment highlights a few key concepts including:
 - Ansible Collections
 - Ansible Operators
 - Ansible Tower running on kubernetes

 ## PreRequisites
 You must have `kubectl` configured on your local system and have it point at a kubernetes cluster.
 The kubernetes cluster *must* have at least 6GB of RAM and 4 CPUs to handle the deployment. 
 
 ### Minikube
 If you're using minikube you can start your machine one time with the following config:
 ` minikube start --memory 6g --cpus 4`

 Or make the changes permament by using the `minikube config` commands

 After the deployment has occured you can use your local resolve file (usually /etc/hosts) to point find the tower app like so:
 `echo "$(minikube ip)    tower.test  " >> /etc/hosts `