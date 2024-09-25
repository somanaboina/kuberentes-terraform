#common variables
ENV          = "prod"
region       = "us-east-1"
project_name = "terraform-kubernetes"

#VPC variables
vpc_cidr         = "192.168.0.0/16"
pub_sub_1_a_cidr = "192.168.0.0/18"
pub_sub_2_b_cidr = "192.168.64.0/18"
pri_sub_3_a_cidr = "192.168.128.0/18"
pri_sub_4_b_cidr = "192.168.192.0/18"

#EKS variables
cluster_svc_cidr                = "10.20.0.0/16"
cluster_version                 = "1.29"
cluster_endpoint_private_access = false
cluster_endpoint_public_access  = true
cluster_endpoint_access_cidr    = ["0.0.0.0/0"]

#eks nodegroup variables
instance_type      = ["t3.medium"]
AMI_type           = "AL2_x86_64"
node_capacity_type = "ON_DEMAND"
node_disk_size     = 20
max_node           = 4
min_node           = 2
desired_node       = 2
#ssh_key_to_access_node = "contol-machine"

#metrics server
metrics_server_driver_namespace = "kube-system"
metrics_server_driver_sa_name   = "metrics-server-sa"

#EBS CSI driver
role_ebs_csi_driver      = "EBSCSIDriver"
ebs_csi_driver_namespace = "kube-system"
ebs_csi_driver_sa_name   = "ebs-csi-controller-sa"

#EFS CSI Driver 
role_efs_csi_driver      = "EFSCSIDriver"
efs_csi_driver_namespace = "kube-system"
efs_csi_driver_sa_name   = "efs-csi-controller-sa"

#Load balancer Driver
role_lbc      = "ALBController"
lbc_namespace = "kube-system"
lbc_sa_name   = "aws-load-balancer-controller"

#ExternalDNS driver
#role_allowexternaldnsupdates = "AllowExternalDNSUpdates-terraform"
role_AllowExternalDNSUpdates = "AllowExternalDNSUpdates-terraform"
external_dns_namespace       = "kube-system"
external_dns_sa_name         = "external-dns-sa"

#Cluster Autoscalar
role_cluster_autoscalar_driver      = "ClusterAutoScalarDriver"
cluster_autoscalar_driver_namespace = "kube-system"
cluster_autoscalar_driver_sa_name   = "cluster-autoscalar-sa"

#Container Insight
role_container_insight_driver      = "ContainerInsight"
container_insight_driver_namespace = "amazon-cloudwatch"
container_insight_driver_sa_name   = "cloudwatch-agent"

#VPC CNI
role_vpc_cni      = "AmazonEKSVPCCNIRole"
vpc_cni_namespace = "kube-system"
vpc_cni_sa_name   = "aws-node"

