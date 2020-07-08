# Terraform-Provisionning

## Description
Cette branche vis à créer le cluster des outils. Ce cluster contient tous les outils de CI/
 CD qu'on va les utiliser. En premier lieu en essayera de faire la mise en place de Gitlab. 
 On peux visiter le site officiel de gitlab pour plus de details: ***https://about.gitlab.com/***

## Steps

### Etape1: faire la misse en place de l'architecture 

>terraform init

>terraform validate

>terraform plan

>terraform apply 

### Etape2: Installation du ingress controller nginx 

Ajouter les lignes suivants au  fichier : kubespray/inventory/my-cluster/group_vars/k8s-cluster/addons.yml

ingress_nginx_enabled: true

ingress_nginx_host_network: true

ingress_publish_status_address: ""

ingress_nginx_nodeselector:

  kubernetes.io/os: "linux"

ingress_nginx_namespace: "ingress-nginx"

ingress_nginx_insecure_port: 80

ingress_nginx_secure_port: 443



### Step4: faire le déploiement de gitlab 

Tous d'abord, clonner le code source :

> git clone https://github.com/ineso/deploy-gitlab-on-minikube

Suivre le readme.md de cette repository.
