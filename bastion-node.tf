resource "google_compute_instance" "vm_instance3" {
  name         = "${var.name}-bastion"
  machine_type = "n1-standard-1"
  zone    = "us-central1-c"
  depends_on    = [google_compute_subnetwork.public-subnetwork]
  //metadata_startup_script = file("script.sh")
  //metadata_startup_script = "nohup sh script.sh > mylogs.out &"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_interface {
    network = "${var.name}-vpc"
    subnetwork = "${var.name}-pubsubnet"

    access_config {
      // Include this section to give the VM an external ip address
    // nat_ip = google_compute_address.bastion.address
    }
  }



provisioner "remote-exec" {
    //script = var.script_path
  connection {
    type        = "ssh"
   // host        = google_compute_address.bastion.address
    host        = google_compute_instance.vm_instance3.network_interface.0.access_config.0.nat_ip 
    user        = "instz"
    port        = "22"
    agent       = true  // this is required to make the local ssh-agent handle keys management 
    // and when you run terraform apply you will be asked to enter the passphrase    

  }
   inline =  [<<EOF
echo '${var.BASTION_PUB_KEY}' > ~/.ssh/id_rsa.pub 
echo '${var.BASTION_PRIV_KEY}' | tr -d '\r' > ~/.ssh/id_rsa 
sudo chmod 700 ~/.ssh/id_rsa 
sudo yum install -y sshpass
sudo yum install -y git 
git clone https://github.com/kubernetes-sigs/kubespray.git

#installation de pip3
sudo yum install -y python36
sudo yum install -y python36-devel
sudo yum install -y python36-setuptools
pip3 -V

#installation des requirements
sudo pip3 install -r kubespray/requirements.txt
cd kubespray/

# spécifier la conf du ansible.cfg
echo "
[privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False
" >> ansible.cfg

cp -rfp inventory/sample inventory/my-cluster
sudo rm inventory.ini 

echo "${template_file.terraform_ansible.rendered}" > inventory/my-cluster/inventory.ini

echo "
[kube-master]
node01
[etcd]
node01
[kube-node]
node02
node03
[calico-rr]
[k8s-cluster:children]
kube-master
kube-node
calico-rr
" >> inventory/my-cluster/inventory.ini

#lancer le playbook

ansible-playbook -i inventory/my-cluster/inventory.ini -b cluster.yml -vvv 
#add kubernetes repo
sudo touch /etc/yum.repos.d/kubernetes.repo
echo " 
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" >> /etc/yum.repos.d/kubernetes.repo
sudo yum install -y kubectl

##creation rep kube
sudo mkdir -p ~/.kube
sudo touch ~/.kube/config

EOF
//sudo scp -r -p ${var.USER_BASTION}@${var.IP_BASTION}:/etc/kubernetes/admin.conf ~/.kube/config



    ]
}

metadata = {  
sshKeys = "instz:${file("/home/instz/.ssh/id_rsa.pub")}" 
}



# We connect to our instance via Terraform and remotely executes our script using SSH
  //provisioner "remote-exec" {
 //   script = var.script_path


  //}

}
// Adding GCP Firewall Rules for INBOUND
resource "google_compute_firewall" "allow-inbound3" {
  name    = "b-${var.in}"
  network = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]


  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

//// Adding GCP Firewall Rules for OUTBOUND
//resource "google_compute_firewall" "allow-outbound3" {
//  name    = "b-${var.out}"
//  network = "${var.name}-vpc"
//  depends_on    = [google_compute_network.vpc_network]
//
//  allow {
//    protocol = "all"
//
//    # ports    = ["all"]
//  }
//
//  source_ranges = ["0.0.0.0/0"]
//}


//# We create a public IP address for our google compute instance to utilize
//resource "google_compute_address" "bastion" {
// name = "vm-public-address"
//}