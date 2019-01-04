variable "aws" {
  type = "map"
  default = {}
}

variable "kubeconfig_path" {}

variable "nginx_ingress" {
  type    = "map"
  default = {}
}

variable "cluster_autoscaler" {
  type    = "map"
  default = {}
}
