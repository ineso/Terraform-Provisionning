resource "google_compute_instance" "vm_instance1" {
  name         = "worker1-node"
  machine_type = "n1-standard-2"
  zone    = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = "${var.name}-vpc"
    subnetwork = "${var.name}-subnet"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    metadata_startup_script = "sudo yum update -y"

    // Apply the firewall rule to allow external IPs to access this instance
   // tags = ["http-server"]
}
// Adding GCP Firewall Rules for INBOUND
resource "google_compute_firewall" "allow-inbound1" {
  name    = "w1-allow-inbound"
  network = "${var.name}-vpc"

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for OUTBOUND
resource "google_compute_firewall" "allow-outbound1" {
  name    = "w1-allow-outbound"
  network = "${var.name}-vpc"

  allow {
    protocol = "all"

    # ports    = ["all"]
  }

  source_ranges = ["0.0.0.0/0"]
}


