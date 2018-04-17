terragrunt = {
  remote_state {
    backend = "gcs"
    config {
      bucket         = "gke-blog-preprod-tf-remote-state"
      prefix         = "${path_relative_to_include()}"
      region         = "europe-west1"
      project        = "gke-blog-preprod"
    }
  }
}
