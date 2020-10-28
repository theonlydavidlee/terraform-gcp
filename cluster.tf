data "google_compute_network" "this" {
  name = "theonlydavidlee-work-1"
}

module "us_central1_1" {
  source = "./clusters/us_central1/us_central1_1"

  project_id = var.project_id

  master_gke_version = "1.16.13-gke.401"
  nodepool_gke_version = "1.16.13-gke.401"

  cluster_name = "us-central1-1"
  network = data.google_compute_network.this.name

  ip_range_master = "10.128.0.32/28"
  ip_range_nodes = "10.128.96.0/19"
  ip_range_pods = "10.140.0.0/14"
  ip_range_services = "10.128.10.64/27"

  master_authorized_networks = local.cluster_master_whitelist
}
