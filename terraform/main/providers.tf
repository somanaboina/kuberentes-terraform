terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}
provider "aws" {
  region = var.region

}
data "aws_eks_cluster" "cluster" {
  name = module.EKS.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.EKS.cluster_id

}
provider "kubernetes" {
  host                   = module.EKS.cluster_endpoint
  cluster_ca_certificate = base64decode(module.EKS.kubeconfig_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token

}
provider "helm" {
  kubernetes {
    host                   = module.EKS.cluster_endpoint
    cluster_ca_certificate = base64decode(module.EKS.kubeconfig_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster_secondary" {
  name = module.EKS.cluster_id
}

