# Creating a kubesray cluster inside a public subnet

## Description
In this branch we will try to build this architecture using terraform 
This is our architecture to build:
 ![alt text](publicsubnet.png) 

 we will try to create a kubernetes cluster using Kubesray. This will be done using a compute engine that will act as a bastion and that will helps to install the kubesray.

## Provisionning infrastructure

### Step1: Download Terraform on your laptop

You can download Terraform from the official site: ***https://www.terraform.io/downloads.html***

### Step2: Setup the Terraform as a environement variable


>unzip terraformfile.zip

>echo "PATH='$PATH:~/downloads/'" >> .bash_profile

>source .bash_profile

>terraform

### Step3: create your service account

In GCP, create your service account with owner permission

### Step4: Create a Service Account Key within the Instance 

>gcloud auth login

>gcloud iam service-accounts keys create credentials.json --iam-account <SERVICE_ACCOUNT>

### Step5: Create the configuration files

You create your configuration files and change your name project and the path to your file ***credentials.json***

### Step6: run your Terraform commands

>terraform init

>terraform validate

>terraform plan

>terraform apply

## Building the kubernetes cluster using kubesray

### Step1: Configure ssh connection

Try to add ssh keys between the bastion compute engine and all others compute engine.

### Step2: clone the kubesray repo

>git clone https://github.com/kubernetes-sigs/kubespray.git

### Step3: Install requirements

>pip3 install -r requirements.txt

### Step4: Copy of the sample

>cp -rfp inventory/sample inventory/my-cluster

### Step5: modify the inventory file

 kubesray is giving you a template of inventory. Try to modify it with your need. add the private ips of your subnet. Then , try to specify the master and the nodes. You can modify the network configuration or add etcd to a node as you wish.

### Step6: 

Run the ansible playbook

>ansible-playbook -i inventory/my-cluster/inventory.ini -k -b cluster.yml


