

resource "aws_iam_role" "vpc-cni-role" {
  name = var.role_vpc_cni

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : var.eks_oidc_connect_provider_arn
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${var.eks_oidc_connect_provider_arn_extract}:aud" : "sts.amazonaws.com",
              "${var.eks_oidc_connect_provider_arn_extract}:sub" : "system:serviceaccount:${var.vpc_cni_namespace}:${var.vpc_cni_sa_name}"
            }
          }
        }
      ]
    }
  )

  tags = {
    Name = var.cluster_id
    env  = var.ENV
  }
}

resource "aws_iam_role_policy_attachment" "vpc-cni-policy-attachment" {
  role       = aws_iam_role.vpc-cni-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_eks_addon" "aws-vpc-cni-addon" {
  cluster_name             = var.cluster_id
  addon_name               = "vpc-cni"
  service_account_role_arn = aws_iam_role.vpc-cni-role.arn
  configuration_values = jsonencode({
    enableNetworkPolicy : "true"
  })
}


