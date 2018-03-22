variable "cluster_name" {
  default = "kubernetes-cluster"
}

variable "node_count" {
  default = 1
}

variable "max_node_count" {
  default = 3
}

variable "min_node_count" {
  default = 1
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = "00000000000000000"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "disk_size_gb" {
  default = "100"
}

variable "master_zone" {
  default = "europe-west1-b"
}

variable "additional_zones" {
  default = [
    "europe-west1-c",
    "europe-west1-d",
  ]
}

variable "min_master_version" {
  default = "1.9.4-gke.1"
}

variable "initial_default_pool_name" {
  default = "unused-default-pool"
}

variable "default_pool_name" {
  default = "default-pool"
}

variable "daily_maintenance_window_start_time" {
  default = "00:00"
}

variable "project" {
  default = "gcp-project"
}

variable "env" {
  default = "sample"
}

variable "kubernetes_network_name" {
  default = "kubernetes-network"
}
