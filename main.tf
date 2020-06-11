provider "google" {
  version = "3.5.0"
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}" 
  region      = "${var.region}"
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "${var.name}-vpc"
  auto_create_subnetworks="false"
}
resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  region        = "${var.region}"
  network       = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network]
  }
