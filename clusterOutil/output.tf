/*************************************************************
    Store master and nodes ips into a template file
 *************************************************************/
resource "template_file" "terraform_ansible" {
  template = file("${path.module}/template_script.tpl")
  vars = {
    name_bastion_priv_key = "${var.BASTION_PRIV_KEY}"
    name_bastion_pub_key = "${var.BASTION_PUB_KEY}"

    priv_escal = "privilege_escalation"
    activ_become = "become=True"
    method= "become_method=sudo"
    activ_root = "become_user=root"
    become_pass= "become_ask_pass=False"
    name_master_host  = "node01"
    name_worker1_host  = "node02"
    name_worker2_host = "node03"
    terraform_ansible_group = "all"
    master_infos = " ansible_host=${google_compute_instance.masteroutil.network_interface.0.network_ip}"
    worker1_infos = " ansible_host=${google_compute_instance.worker1outil.network_interface.0.network_ip}"
    worker2_infos = " ansible_host=${google_compute_instance.worker2outil.network_interface.0.network_ip}"
    ip_master = "ip = ${google_compute_instance.masteroutil.network_interface.0.network_ip}"
    etcd_master ="etcd_member_name=etcd1"
    group_master="kube-master"
    group_workers="kube-node"
    netw_group ="calico-rr"
    k8s_cluster_comp ="k8s-cluster:children"
    repo ="kubernetes"
    name_repo = "name=Kubernetes"
    url_repo="baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64"
    enable_repo ="enabled=1"
    gpg_key_pass ="gpgcheck=1"
    repo_gpgcheck="repo_gpgcheck=1"
    gpg_key="gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.clo"

  }
}


/*************************************************************
    return the ansible inventory as terraform output 
 *************************************************************/
output "script_template" {
	value = "${template_file.terraform_ansible.rendered}"
}


//output "bastion-ip" {
//  value = google_compute_instance.vm_instance3.network_interface.0.access_config.0.nat_ip
//}

//output "master-ip" {
//  value = google_compute_instance.vm_instance.network_interface.0.network_ip
//}
//output "worker1-ip" {
//  value = google_compute_instance.vm_instance1.network_interface.0.network_ip
//}
//output "worker2-ip" {
//  value = google_compute_instance.vm_instance2.network_interface.0.network_ip
//}