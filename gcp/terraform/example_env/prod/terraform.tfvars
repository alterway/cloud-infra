terragrunt = {
  remote_state {
    backend = "gcs"
    config {
      bucket         = "gke-blog-prod-remote-state"
      prefix         = "${path_relative_to_include()}"
      region         = "europe-west1"
      project        = "gke-blog-prod"
    }
  }
}
