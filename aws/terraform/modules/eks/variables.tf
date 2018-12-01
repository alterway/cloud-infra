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

variable "domain_name" {
  description = "Domain name of the parent domain where subdomain is created"
  default     = "cloud.ger.systems"
}

variable "subdomain_name" {
  description = "Subdomain name used to create an independant DNS zone"
  default     = "staging2.customerhappiness"
}

variable "subdomain_default_ttl" {
  description = "Subdomain zone default TTL"
  default     = "300"
}
