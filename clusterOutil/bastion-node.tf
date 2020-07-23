resource "google_compute_instance" "bastionoutil" {
  name         = "${var.name}-bastion"
  machine_type = "n1-standard-1"
  zone    = "us-central1-c"
  depends_on    = [google_compute_subnetwork.public-suboutil]


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
    host        = google_compute_instance.bastionoutil.network_interface.0.access_config.0.nat_ip 
    user        = "instz"
    port        = "22"
    agent       = true  // this is required to make the local ssh-agent handle keys management 
    // and when you run terraform apply you will be asked to enter the passphrase    

  }
   inline =  ["${template_file.terraform_ansible.rendered}"]
}

metadata = {  
sshKeys = "instz:${file("/home/instz/.ssh/id_rsa.pub")}" 
}



# We connect to our instance via Terraform and remotely executes our script using SSH
  //provisioner "remote-exec" {
 //   script = var.script_path


  //}

}


//# We create a public IP address for our google compute instance to utilize
//resource "google_compute_address" "bastion" {
// name = "vm-public-address"
//}