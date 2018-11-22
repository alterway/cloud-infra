#
# Variables Configuration
#

variable "cluster-name" {
  default = "sample-cluster"
  type    = "string"
}

variable "aws-region" {
  default = "eu-west-1"
  type    = "string"
}

variable "node-pools" {
  default = []
  type    = "list"
}
