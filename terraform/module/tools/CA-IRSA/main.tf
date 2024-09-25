resource "aws_iam_policy" "clusterAutoscalar-policy" {
  name        = "${var.role_cluster_autoscalar_driver}-policy"
  path        = "/"
  description = "This policy will give enough permisson to IRSA so that it can talk to ASG+NodeGroup"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource" : ["*"]
      }
    ]
  })
}


resource "aws_iam_role" "clusterAutoscalar-role" {
  name = var.role_cluster_autoscalar_driver

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
              "${var.eks_oidc_connect_provider_arn_extract}:sub" : "system:serviceaccount:${var.cluster_autoscalar_driver_namespace}:${var.cluster_autoscalar_driver_sa_name}"
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

resource "aws_iam_role_policy_attachment" "clusterAutoscalar-policy-attachment" {
  role       = aws_iam_role.clusterAutoscalar-role.name
  policy_arn = aws_iam_policy.clusterAutoscalar-policy.arn
}

/*

There are 1 Ways to Deploy Driver

# 🔸 Helm

*/

# 🔸 Helm
# Lets install EBS CSI Driver through helm provider

resource "helm_release" "helm-clusterAutoscalar-driver" {
  depends_on = [ aws_iam_role_policy_attachment.clusterAutoscalar-policy-attachment  ]
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.cluster_autoscalar_driver_namespace

  set {
    name  = "cloudProvider"
    value = "aws"
  }
  set {
    name  = "awsRegion"
    value = "us-east-1"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.cluster_id}"
  }
  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = var.cluster_autoscalar_driver_sa_name
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.clusterAutoscalar-role.arn}"
  }
}

