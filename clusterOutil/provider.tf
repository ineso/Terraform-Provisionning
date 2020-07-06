provider "google" {
  version = "3.5.0"
  credentials = file("../credentials.json")
  project     = var.gcp_project
  region      = var.region
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network_outil" {
  name = "${var.name}-vpc"
  auto_create_subnetworks="false"
}

resource "google_compute_subnetwork" "public-suboutil" {
  name          = "${var.name}-pubsubnet"
  ip_cidr_range = var.pub_subnet_cidr
  region        = var.region
  network       = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network_outil]
}

resource "google_compute_subnetwork" "private-suboutil" {
  name          = "${var.name}-privsubnet"
  ip_cidr_range = var.prv_subnet_cidr
  region        = var.region
  network       = "${var.name}-vpc"
  depends_on    = [google_compute_network.vpc_network_outil]
  private_ip_google_access = "true"
}
