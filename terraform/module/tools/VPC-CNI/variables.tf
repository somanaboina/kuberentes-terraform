# Common variable for creating role and policy
variable "cluster_id" {}
variable "ENV" {}
variable "eks_oidc_connect_provider_arn" {}
variable "eks_oidc_connect_provider_arn_extract" {}


#  specific variable
variable "role_vpc_cni" {}
variable "vpc_cni_namespace" {}
variable "vpc_cni_sa_name" {}

