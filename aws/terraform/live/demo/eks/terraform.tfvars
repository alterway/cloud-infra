terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "github.com/osones/cloud-infra.git//aws/terraform/modules/eks"
  }
}

//
// [provider]
//
aws-region = "eu-west-1"

//
// [kubernetes]
//
cluster-name = "staging"

node-pools = [
  {
    name = "default"
    min_size = 3
    max_size = 9
    desired_capacity = 3
    instance_type = "m4.large"
    key_name = "keypair"
    volume_size = 30
    volume_type = "gp2"
    autoscaling = "enabled"
  },
]
