resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = "true"
  reclaim_policy         = "Retain"
}

resource "kubernetes_persistent_volume_claim_v1" "ebs_mongo_pv_claim" {
  metadata {
    name = "ebs-mongo-pv-claim"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata.0.name
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}