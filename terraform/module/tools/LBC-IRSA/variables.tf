# Common variable for creating role and policy
variable "cluster_id" {}
variable "ENV" {}
variable "eks_oidc_connect_provider_arn" {}
variable "eks_oidc_connect_provider_arn_extract" {}


#  specific variable
variable "role_lbc" {}
variable "lbc_namespace" {}
variable "lbc_sa_name" {}

