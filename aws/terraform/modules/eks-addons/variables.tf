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

variable "external_dns" {
  type    = "map"
  default = {}
}

variable "cert_manager" {
  type    = "map"
  default = {}
}
