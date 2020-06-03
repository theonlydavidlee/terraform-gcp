locals {
  region = "us-central1"
  node_locations = [
    "us-central1-a",
    "us-central1-b"
  ]
}

resource "google_compute_subnetwork" "this" {
  name = "${var.cluster_name}-subnet"

  ip_cidr_range = var.ip_range_nodes
  region = local.region
  network = var.network
  private_ip_google_access = true
  secondary_ip_range {
    range_name = "pod-cidr"
    ip_cidr_range = var.ip_range_pods
  }
  secondary_ip_range {
    range_name = "services-cidr"
    ip_cidr_range = var.ip_range_services
  }
}

module "gke_private_cluster" {
  source = "../../../modules/cluster/private"

  project_id = var.project_id

  cluster_name = var.cluster_name
  region = local.region

  min_master_version = var.master_gke_version

  network = var.network
  subnetwork = google_compute_subnetwork.this.name
  node_locations = local.node_locations

  enable_private_nodes = true
  enable_private_endpoint = false

  master_ipv4_cidr_block = var.ip_range_master
  pods_secondary_range = "pod-cidr"
  services_secondary_range = "services-cidr"
  default_max_pods_per_node = 16

  master_authorized_networks = var.master_authorized_networks
  http_load_balancing = false
}

module "kube_services_pool_1" {
  source = "../../../modules/nodepool"

  nodepool_name = "pool-1"
  nodepool_gke_version = var.nodepool_gke_version

  cluster_name = module.gke_private_cluster.name
  location = local.region

  initial_node_count = 1

  autoscaling = {
    enabled = true
    min_node_count = 1
    max_node_count = 6
  }

  node_config = {
    machine_type = "n1-standard-1"
  }
}
