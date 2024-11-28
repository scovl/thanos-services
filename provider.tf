provider "aws" {
  region = "sa-east-1"
}

provider "kubernetes" {
  alias = "pro"
  host  = data.aws_eks_cluster.cluster_pro.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_pro.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster_pro.name]
  }
}

provider "helm" {
  alias = "pro"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster_pro.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_pro.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster_pro.name]
    }
  }
}
