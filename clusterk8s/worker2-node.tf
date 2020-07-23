resource "google_compute_instance" "vm_instance2" {
  name         = "worker2-node"
  machine_type = "n1-standard-2"
  zone    = "us-central1-c"
  depends_on    = [google_compute_subnetwork.private-subnetwork]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "${var.name}-vpc"
    subnetwork = "${var.name}-privsubnet"

    access_config {
      // Include this section to give the VM an external ip address
    }

  }
  metadata = {  
   sshKeys = "instz:${file("/home/instz/.ssh/id_rsa.pub")}" 
  }

  metadata_startup_script = ""

    // Apply the firewall rule to allow external IPs to access this instance
   // tags = ["http-server"]
  
}

// Adding GCP Firewall Rules for INBOUND
//resource "google_compute_firewall" "allow-inbound2" {
//  name    = "w2-${var.in}"
//  network = "${var.name}-vpc"
//  depends_on    = [google_compute_network.vpc_network]
//
//  allow {
//    protocol = "tcp"
//    ports    = ["80","22"]
//  }
//
//  source_ranges = ["0.0.0.0/0"]
//}
//
////// Adding GCP Firewall Rules for OUTBOUND
//resource "google_compute_firewall" "allow-outbound2" {
//  name    = "w2-${var.out}"
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


