terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "terraform-remote-state"
      key            = "${path_relative_to_include()}"
      region         = "eu-west-1"
      encrypt        = true
      dynamodb_table = "terraform-remote-state"
    }
  }
}
