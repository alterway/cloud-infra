terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
  terraform {
    source = "../../../modules//eks-addons"
    before_hook "kubeconfig" {
      commands = ["apply"]
      execute = ["bash","-c","cp ${get_tfvars_dir()}/../eks/kubeconfig kubeconfig"]
    }
  }
}

//
// [provider]
//
aws = {
  "region" = "eu-west-1"
}
kubeconfig_path = "./kubeconfig"

//
// [nginx_ingress]
//
nginx_ingress = {
  version = "0.21.0"
  chart_version = "1.1.2"
  enabled = true
  namespace = "ingress-nginx"
  extra_values = ""
}

//
// [cluster_autoscaler]
//
cluster_autoscaler = {
  version = "v1.3.5"
  chart_version = "0.11.0"
  enabled = true
  namespace = "cluster-autoscaler"
  cluster_name = "sample"
  extra_values = ""
}

//
// [external_dns]
//
external_dns = {
  version = "v0.5.9"
  chart_version = "1.3.0"
  enabled = true
  namespace = "external-dns"
  extra_values = ""
}

//
// [cert_manager]
//
cert_manager = {
  version = "v0.5.2"
  chart_version = "v0.5.2"
  enabled = true
  namespace = "cert-manager"
  extra_values = ""
}
