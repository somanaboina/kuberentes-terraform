#variables
#common variables
variable "ENV" {}
variable "region" {}
variable "project_name" {}

#VPC variables
variable "vpc_cidr" {}
variable "pub_sub_1_a_cidr" {}
variable "pub_sub_2_b_cidr" {}
variable "pri_sub_3_a_cidr" {}
variable "pri_sub_4_b_cidr" {}

#EKS cluster variables

variable "cluster_svc_cidr" {}
variable "cluster_version" {}
variable "cluster_endpoint_private_access" {}
variable "cluster_endpoint_public_access" {}
variable "cluster_endpoint_access_cidr" {}

#EKS nodegroup variables
variable "instance_type" {}
variable "AMI_type" {}
variable "node_capacity_type" {}
variable "node_disk_size" {}
variable "max_node" {}
variable "min_node" {}
variable "desired_node" {}
#variable "ssh_key_to_access_node" {}

# variables for metric server
variable "metrics_server_driver_namespace" {}
variable "metrics_server_driver_sa_name" {}

# variables for EBS CSI driver
variable "role_ebs_csi_driver" {}
variable "ebs_csi_driver_namespace" {}
variable "ebs_csi_driver_sa_name" {}

#variables for EFS driver
variable "role_efs_csi_driver" {}
variable "efs_csi_driver_namespace" {}
variable "efs_csi_driver_sa_name" {}

#variable for AWS LBC
variable "role_lbc" {}
variable "lbc_namespace" {}
variable "lbc_sa_name" {}

#variable for external-dns
variable "role_AllowExternalDNSUpdates" {}
variable "external_dns_namespace" {}
variable "external_dns_sa_name" {}

#variables for cluster autoscalar
variable "role_cluster_autoscalar_driver" {}
variable "cluster_autoscalar_driver_namespace" {}
variable "cluster_autoscalar_driver_sa_name" {}

#variables for container Insight
variable "role_container_insight_driver" {}
variable "container_insight_driver_namespace" {}
variable "container_insight_driver_sa_name" {}

#variables for VPC CNI
variable "role_vpc_cni" {}
variable "vpc_cni_namespace" {}
variable "vpc_cni_sa_name" {}
