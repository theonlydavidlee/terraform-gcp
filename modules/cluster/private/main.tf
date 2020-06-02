resource "google_container_cluster" "this" {
  provider = google-beta

  name = var.cluster_name
  location = var.region

  min_master_version = var.min_master_version

  network = "projects/${var.project_id}/global/networks/${var.network}"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

  node_locations = var.node_locations

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes = var.enable_private_nodes
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block = var.master_ipv4_cidr_block
    }] : []

    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name = var.pods_secondary_range
    services_secondary_range_name = var.services_secondary_range
  }
  default_max_pods_per_node = var.default_max_pods_per_node

  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) == 0 ? [] : [{
      cidr_blocks : var.master_authorized_networks
    }]
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }
  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = ! var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = ! var.network_policy
    }

    dns_cache_config {
      enabled = var.dns_cache
    }
  }
  maintenance_policy {
    daily_maintenance_window {
      start_time = "23:00"
    }
  }
  initial_node_count = 1
  remove_default_node_pool = true
}
