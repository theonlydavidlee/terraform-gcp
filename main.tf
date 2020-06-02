terraform {
  required_version = "0.12.24"
  backend "gcs" {
    bucket = "theonlydavidlee-work-1-tf"
    prefix = "gcp"
  }
}

provider "google" {
  version = "3.23.0"
  project = var.project_id
}

provider "google-beta" {
  version = "3.23.0"
  project = var.project_id
}

locals {
  cluster_master_whitelist = [
    {
      cidr_block = "0.0.0.0/0"
      display_name = "Unrestricted"
    }
  ]
}
