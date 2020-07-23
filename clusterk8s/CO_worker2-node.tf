resource "google_compute_instance" "worker2outil" {
  name         = "${var.nameco}-worker2"
  machine_type = "n1-standard-2"
  zone    = "us-central1-c"
  depends_on    = [google_compute_subnetwork.private-suboutil]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "${var.name}-vpc"
    subnetwork = "${var.nameco}-privsubnet"

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

#// Adding GCP Firewall Rules for INBOUND
#resource "google_compute_firewall" "allow-inbound-worker2-outil" {
#  name    = "w2-outil-${var.in}"
#  network = "${var.name}-vpc"
#  depends_on    = [google_compute_network.vpc_network]
#  allow {
#    protocol = "tcp"
#    ports    = ["80","22"]
#  }
#
#  source_ranges = ["0.0.0.0/0"]
#}
#
#//// Adding GCP Firewall Rules for OUTBOUND
#resource "google_compute_firewall" "allow-outbound-worker2-outil" {
#  name    = "w2-outil-${var.out}"
#  network = "${var.name}-vpc"
#  depends_on    = [google_compute_network.vpc_network]
#
#  allow {
#    protocol = "all"
#
#    # ports    = ["all"]
#  }
#
#  source_ranges = ["0.0.0.0/0"]
#}


