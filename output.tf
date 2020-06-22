/*************************************************************
    Store master and nodes ips into a template file
 *************************************************************/
resource "template_file" "terraform_ansible" {
  template = file("${path.module}/hostname.tpl")
  vars = {
    name_master_host  = "node01"
    name_worker1_host  = "node02"
    name_worker2_host = "node03"
    terraform_ansible_group = "all"
    master_infos = " ansible_host=${google_compute_instance.vm_instance.network_interface.0.network_ip}"
    worker1_infos = " ansible_host=${google_compute_instance.vm_instance1.network_interface.0.network_ip}"
    worker2_infos = " ansible_host=${google_compute_instance.vm_instance2.network_interface.0.network_ip}"
  
  }
}

/*************************************************************
    return the ansible inventory as terraform output 
 *************************************************************/
output "ansible_hosts" {
	value = "${template_file.terraform_ansible.rendered}"
}


//output "bastion-ip" {
//  value = google_compute_instance.vm_instance3.network_interface.0.access_config.0.nat_ip
//}//

//output "master-ip" {
//  value = google_compute_instance.vm_instance.network_interface.0.network_ip
//}
//output "worker1-ip" {
//  value = google_compute_instance.vm_instance1.network_interface.0.network_ip
//}
//output "worker2-ip" {
//  value = google_compute_instance.vm_instance2.network_interface.0.network_ip
//}