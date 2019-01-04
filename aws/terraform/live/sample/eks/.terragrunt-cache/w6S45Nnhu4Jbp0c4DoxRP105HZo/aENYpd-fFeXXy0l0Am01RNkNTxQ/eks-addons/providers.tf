
#
# Provider Configuration
#
terraform {
  backend "s3" {}
}

provider "helm" {
  install_tiller = true
  service_account = "tiller"
  automount_service_account_token = true
  kubernetes {
    config_path = "${var.kubeconfig_path}"
  }
}

provider "kubernetes" {
  config_path = "${var.kubeconfig_path}"
}
