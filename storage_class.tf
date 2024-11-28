resource "kubernetes_storage_class" "encrypted_gp2_pro" {
  metadata {
    name = "encrypted-gp2"
    labels = {
      environment = "production"
    }
  }

  provisioner          = "kubernetes.io/aws-ebs"
  volume_binding_mode  = "WaitForFirstConsumer"
  reclaim_policy       = "Delete"
  parameters = {
    type      = "gp2"
    fsType    = "ext4"
    encrypted = "true"
  }
}
