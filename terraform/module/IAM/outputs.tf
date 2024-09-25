output "eks_main_role_id" {
  value = aws_iam_role.eks-cluster-main.id
}
output "eks_main_role_arn" {
  value = aws_iam_role.eks-cluster-main.arn
}
output "eks_main_role_name" {
  value = aws_iam_role.eks-cluster-main.name
}

output "eks_main_nodegroup_role_id" {
  value = aws_iam_role.eks-nodegroup-main.id
}
output "eks_main_nodegroup_role_arn" {
  value = aws_iam_role.eks-nodegroup-main.arn
}
output "eks_main_nodegroup_role_name" {
  value = aws_iam_role.eks-nodegroup-main.name
}

