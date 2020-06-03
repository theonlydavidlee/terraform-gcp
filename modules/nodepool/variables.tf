variable "nodepool_name" {
  type = string
}

variable "nodepool_gke_version" {
  type = string
}

variable "initial_node_count" {
  type = number
  default = 0
}

variable "cluster_name" {
  type = string
}

variable "upgrade_settings" {
  description = "Node surge upgrade settings"
  default = {}
}

variable "location" {
  type = string
  description = "Region or zone of the cluster, depending on the type of cluster"
}

variable "autoscaling" {
  description = "Autoscaling configuration, such as, min_node_count, max_node_count; must set enabled=true to configure autoscaling settings."

  default = {
    enabled = false
  }
}

variable "node_config" {
  description = "Nodepool configuration, such as, machine_type, labels, taints, etc."
}
