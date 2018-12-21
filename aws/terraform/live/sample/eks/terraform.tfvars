terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "github.com/osones/cloud-infra.git//aws/terraform/modules/eks"

    after_hook "kubeconfig" {
      commands = ["apply"]
      execute = ["bash","-c","terraform output kubeconfig 2>/dev/null > ${get_tfvars_dir()}/kubeconfig"]
    }
    after_hook "configmap" {
      commands = ["apply"]
      execute = ["bash","-c","terraform output config_map_aws_auth 2>/dev/null | kubectl --kubeconfig ${get_tfvars_dir()}/kubeconfig apply -f -"]

    }

  }

}

//
// [provider]
//
aws-region = "eu-west-1"

//
// [dns]
//
use_route53 = false
domain_name = "domain.tld"
subdomain_name = "subdomain.domain.tld"

//
// [kubernetes]
//
cluster-name = "sample"

node-pools = [
  {
    name = "default"
    min_size = 3
    max_size = 9
    desired_capacity = 3
    instance_type = "t3.medium"
    key_name = "keypair"
    volume_size = 30
    volume_type = "gp2"
    autoscaling = "enabled"
  },
]
