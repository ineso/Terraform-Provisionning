echo '${name_bastion_pub_key}' > ~/.ssh/id_rsa.pub
echo '${name_bastion_priv_key}' | tr -d '\r' > ~/.ssh/id_rsa 
sudo chmod 700 ~/.ssh/id_rsa 
sudo yum install -y sshpass
sudo yum install -y git 
git clone https://github.com/kubernetes-sigs/kubespray.git

sudo yum install -y python36
sudo yum install -y python36-devel
sudo yum install -y python36-setuptools
pip3 -V

sudo pip3 install -r kubespray/requirements.txt
cd kubespray/

echo "
[${priv_escal}]
${activ_become}
${method}
${activ_root}
${become_pass}
" >> ansible.cfg

cp -rfp inventory/sample inventory/my-cluster
sudo rm -rf  inventory/my-cluster/inventory.ini
echo "

[${terraform_ansible_group}]
${name_master_host} ${master_infos} 
${name_worker1_host} ${worker1_infos}
${name_worker2_host} ${worker2_infos}

[${group_master}]
${name_master_host}
[etcd]
${name_master_host}
[${group_workers}]
${name_worker1_host}
${name_worker2_host}
[${netw_group}]
[${k8s_cluster_comp}]
${group_master}
${group_workers}
${netw_group}
 " >> inventory/my-cluster/inventory.ini

ansible-playbook -i inventory/my-cluster/inventory.ini -b cluster.yml -vvv 

sudo touch /etc/yum.repos.d/kubernetes.repo
echo " 
[${repo}]
${name_repo}
${url_repo}
${enable_repo}
${gpg_key_pass}
${repo_gpgcheck}
${gpg_key} " >> /etc/yum.repos.d/kubernetes.repo 

sudo yum install -y kubectl

sudo mkdir -p ~/.kube
sudo touch ~/.kube/config
