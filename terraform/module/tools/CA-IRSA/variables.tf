# Common variable for creating role and policy
variable "cluster_id" {}
variable "ENV" {}
variable "eks_oidc_connect_provider_arn" {}
variable "eks_oidc_connect_provider_arn_extract" {}


#  specific variable
variable "role_cluster_autoscalar_driver" {}
variable "cluster_autoscalar_driver_namespace" {}
variable "cluster_autoscalar_driver_sa_name" {}
