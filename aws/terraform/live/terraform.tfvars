terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "eks-terraform-remote-state"
      key            = "${path_relative_to_include()}"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "eks-terraform-remote-state"
    }
  }
}
