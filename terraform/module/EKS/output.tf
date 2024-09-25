output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_arn" {
  value = aws_eks_cluster.cluster.arn

}

output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}
output "cluster_security_group_id" {
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}
output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

/*
# Public NODEGROUP OUTPUT - Uncomment below output if you have PUBLIC NODEGROUP

output "NODEGROUP_PUBLIC_ID" {
  value = aws_eks_node_group.public-nodegroup.id
}

output "NODEGROUP_PUBLIC_STATUS" {
  value = aws_eks_node_group.public-nodegroup.status

}
output "NODEGROUP_PUBLIC_VERSION" {

  value = aws_eks_node_group.public-nodegroup.version
}
output "NODEGROUP_PUBLIC_ARN" {

  value = aws_eks_node_group.public-nodegroup.arn
}
*/


# Private NODEGROUP OUTPUT

output "nodegroup_private_id" {
  value = aws_eks_node_group.private-nodegroup.id
}

output "nodegroup_private_status" {
  value = aws_eks_node_group.private-nodegroup.status

}
output "nodegroup_private_version" {

  value = aws_eks_node_group.private-nodegroup.version
}
output "nodegroup_private_arn" {

  value = aws_eks_node_group.private-nodegroup.arn
}

output "eks_oidc_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.eks-oidc.arn
}
output "eks_oidc_connect_provider_arn_extract" {
  value = element(split("oidc-provider/", aws_iam_openid_connect_provider.eks-oidc.arn), 1)
}
