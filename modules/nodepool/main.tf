locals {
  node_config = {
    disk_type = "pd-standard"
    image_type = "COS"
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}


resource "google_container_node_pool" "this" {
  name = var.nodepool_name
  version = var.nodepool_gke_version

  cluster = var.cluster_name
  location = var.location

  management {
    auto_repair = true
    auto_upgrade = false
  }

  initial_node_count = var.initial_node_count

  dynamic "autoscaling" {
    for_each = lookup(var.autoscaling, "enabled", false) ? [var.autoscaling] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_node_count", null)
      max_node_count = lookup(autoscaling.value, "max_node_count", null)
    }
  }

  upgrade_settings {
    max_surge = lookup(var.upgrade_settings, "max_surge", 2)
    max_unavailable = lookup(var.upgrade_settings, "max_unavailable", 0)
  }

  node_config {
    machine_type = var.node_config.machine_type
    preemptible = lookup(var.node_config, "preemptible", false)

    min_cpu_platform = lookup(var.node_config, "min_cpu_platform", null)
    disk_size_gb = lookup(var.node_config, "disk_size_gb", local.node_config.disk_size_gb)

    labels = lookup(var.node_config, "labels", null)
    taint = lookup(var.node_config, "taint", null)

    image_type = lookup(var.node_config, "image_type", local.node_config.image_type)
    disk_type = lookup(var.node_config, "disk_type", local.node_config.disk_type)

    oauth_scopes = lookup(var.node_config, "oauth_scopes", local.node_config.oauth_scopes)
  }
}
