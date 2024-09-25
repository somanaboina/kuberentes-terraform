# Common variable for creating role and policy
variable "cluster_id" {}
variable "ENV" {}
variable "eks_oidc_connect_provider_arn" {}
variable "eks_oidc_connect_provider_arn_extract" {}


#  specific variable
variable "role_AllowExternalDNSUpdates" {}
variable "external_dns_namespace" {}
variable "external_dns_sa_name" {}

