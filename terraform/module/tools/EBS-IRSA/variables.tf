# Common variable for creating role and policy
variable "cluster_id" {}
variable "ENV" {}
variable "eks_oidc_connect_provider_arn" {}
variable "eks_oidc_connect_provider_arn_extract" {}


#  specific variable
variable "role_ebs_csi_driver" {}
variable "ebs_csi_driver_namespace" {}
variable "ebs_csi_driver_sa_name" {}

