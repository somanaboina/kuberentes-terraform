variable "project_name" {}
variable "eks_main_role_arn" {}
variable "cluster_version" {}

variable "pub_sub_1_a_id" {}
variable "pub_sub_2_b_id" {}
variable "pri_sub_3_a_id" {}
variable "pri_sub_4_b_id" {}


variable "cluster_endpoint_private_access" {}
variable "cluster_endpoint_public_access" {}

variable "cluster_endpoint_access_cidr" {}
variable "cluster_svc_cidr" {}
variable "eks_main_nodegroup_role_arn" {}
variable "ENV" {}
variable "region" {}

variable "instance_type" {}
variable "AMI_type" {}
variable "node_capacity_type" {}
variable "node_disk_size" {}
variable "max_node" {}
variable "min_node" {}
variable "desired_node" {}
# variable "SSH_KEY_TO_ACCESS_NODE" {}

# variable "EKS_OIDC_ROOT_CA_THUMBPRINT" {}

