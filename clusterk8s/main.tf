provider "google" {
  version = "3.5.0"
  credentials = file("../credentials.json")
  project     = var.gcp_project
  region      = var.region
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "${var.name}-vpc"
  auto_create_subnetworks="false"
}

resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "${var.name}-pubsubnet"
  ip_cidr_range = var.pub_subnet_cidr
  region        = var.region
  network       = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]
}

resource "google_compute_subnetwork" "private-subnetwork" {
  name          = "${var.name}-privsubnet"
  ip_cidr_range = var.prv_subnet_cidr
  region        = var.region
  network       = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]
  private_ip_google_access = "true"
}

// Adding GCP Firewall Rules for INBOUND
resource "google_compute_firewall" "allow-inbound" {
  name    = "${var.in}"
  network = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]


  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

//// Adding GCP Firewall Rules for OUTBOUND
resource "google_compute_firewall" "allow-outbound" {
  name    = "${var.out}"
  network = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]

  allow {
    protocol = "all"

    # ports    = ["all"]
  }

  source_ranges = ["0.0.0.0/0"]
}
