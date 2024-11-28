data "aws_eks_cluster" "cluster_pro" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster_pro" {
  name = var.cluster_name
}

data "aws_ssm_parameter" "grafana_admin_password" {
  name = "/grafana/admin_password"
}