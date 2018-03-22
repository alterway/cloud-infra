# Infrastructure as a Code

Infrastructure templates for various providers with various tooling.

## AWS

Cloudformation Templates for AWS:

- [AWS/ECS](./aws/cloudformation/ecs)
- [AWS/LAMBDA](./aws/cloudformation/lambda)

## GCP

Terraform modules:

- [GCP/GKE](./gcp/terraform/gke)

Terraform modules works in conjunction with
[Terragrunt](https://github.com/gruntwork-io/terragrunt) to provide remote state
storage, locking and environment repeatability.

Samples configuration per modules are available [here](./gcp/terraform/live)
