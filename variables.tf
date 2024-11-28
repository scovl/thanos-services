variable "ssm_prefix" {
  description = "SSM Parameter Store Prefix for Account Information"
  type        = string
  default     = "/Observability-{account_id}/Account/Information/"
}

variable "consumers" {
  description = "Mapping consumers with configuration values"
  type = map(object({
    values             = string
    yace_active        = bool
    prometheus_active  = bool
  }))
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-metrics-pro"
}
