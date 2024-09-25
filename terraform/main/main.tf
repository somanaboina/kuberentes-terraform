# Create VPC

module "VPC" {
  source           = "../module/VPC"
  region           = var.region
  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr
  pub_sub_1_a_cidr = var.pub_sub_1_a_cidr
  pub_sub_2_b_cidr = var.pub_sub_2_b_cidr
  pri_sub_3_a_cidr = var.pri_sub_3_a_cidr
  pri_sub_4_b_cidr = var.pri_sub_4_b_cidr

}

# create IAM roles with required permission

module "IAM" {
  source       = "../module/IAM"
  project_name = module.VPC.project_name
  ENV          = var.ENV
}

# Create EKS cluster + NodeGroup
module "EKS" {
  source                          = "../module/EKS"
  project_name                    = module.VPC.project_name
  eks_main_role_arn               = module.IAM.eks_main_role_arn
  ENV                             = var.ENV
  region                          = var.region
  cluster_version                 = var.cluster_version
  pub_sub_1_a_id                  = module.VPC.pub_sub_1_a_id
  pub_sub_2_b_id                  = module.VPC.pub_sub_2_b_id
  pri_sub_3_a_id                  = module.VPC.pri_sub_3_a_id
  pri_sub_4_b_id                  = module.VPC.pri_sub_4_b_id
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_access_cidr    = var.cluster_endpoint_access_cidr
  cluster_svc_cidr                = var.cluster_svc_cidr
  eks_main_nodegroup_role_arn     = module.IAM.eks_main_nodegroup_role_arn
  instance_type                   = var.instance_type
  AMI_type                        = var.AMI_type
  node_capacity_type              = var.node_capacity_type
  node_disk_size                  = var.node_disk_size
  max_node                        = var.max_node
  min_node                        = var.min_node
  desired_node                    = var.desired_node
  # ssh_key_to_access_node           = var.ssh_key_to_access_node


}
# Deploy VPC-CNI addon

module "IAM_VPC_CNI" {
  depends_on                            = [module.EKS]
  source                                = "../module/tools/VPC-CNI"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_vpc_cni                          = var.role_vpc_cni
  vpc_cni_namespace                     = var.vpc_cni_namespace
  vpc_cni_sa_name                       = var.vpc_cni_sa_name
}

# Deploy Metrics server

module "metric_server" {
  depends_on                      = [module.EKS]
  source                          = "../module/tools/Metrics_server"
  metrics_server_driver_namespace = var.metrics_server_driver_namespace
  metrics_server_driver_sa_name   = var.metrics_server_driver_sa_name

}

# Deploy EBS CSI Driver
module "IAM_ebs_csi" {
  depends_on                            = [module.IAM_VPC_CNI]
  source                                = "../module/tools/EBS-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_ebs_csi_driver                   = var.role_ebs_csi_driver
  ebs_csi_driver_namespace              = var.ebs_csi_driver_namespace
  ebs_csi_driver_sa_name                = var.ebs_csi_driver_sa_name

}

# Deploy EFS CSI Driver

module "IAM_efs_csi" {
  depends_on                            = [module.EKS]
  source                                = "../module/tools/EFS-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_efs_csi_driver                   = var.role_efs_csi_driver
  efs_csi_driver_namespace              = var.role_efs_csi_driver
  efs_csi_driver_sa_name                = var.efs_csi_driver_sa_name

}

# Deploy AWS Load balancer Controller

module "IAM_LBC" {
  depends_on                            = [module.EKS]
  source                                = "../module/tools/LBC-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_lbc                              = var.role_lbc
  lbc_namespace                         = var.lbc_namespace
  lbc_sa_name                           = var.lbc_sa_name
}
#Deploy External DNS
module "IAM_externaldns" {
  depends_on                            = [module.IAM_VPC_CNI]
  source                                = "../module/tools/ExternalDNS-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_AllowExternalDNSUpdates          = var.role_AllowExternalDNSUpdates
  external_dns_namespace                = var.external_dns_namespace
  external_dns_sa_name                  = var.external_dns_sa_name

}

# Deploy Cluster Autoscalar

module "IAM_cluster_autoscalar" {
  depends_on                            = [module.IAM_VPC_CNI]
  source                                = "../module/tools/CA-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_cluster_autoscalar_driver        = var.role_cluster_autoscalar_driver
  cluster_autoscalar_driver_namespace   = var.cluster_autoscalar_driver_namespace
  cluster_autoscalar_driver_sa_name     = var.cluster_autoscalar_driver_sa_name

}

# Deploy Container Insight

module "IAM_container_insight" {
  depends_on                            = [module.IAM_VPC_CNI]
  source                                = "../module/tools/Container-insights-IRSA"
  ENV                                   = var.ENV
  cluster_id                            = module.EKS.cluster_id
  eks_oidc_connect_provider_arn         = module.EKS.eks_oidc_connect_provider_arn
  eks_oidc_connect_provider_arn_extract = module.EKS.eks_oidc_connect_provider_arn_extract
  role_container_insight_driver         = var.role_container_insight_driver
  container_insight_driver_namespace    = var.container_insight_driver_namespace
  container_insight_driver_sa_name      = var.container_insight_driver_sa_name

}
