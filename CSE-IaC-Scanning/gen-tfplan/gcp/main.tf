resource "google_bigtable_instance" "negative" {
  name = "tf-instance-1"

  cluster {
    cluster_id   = "tf-instance-cluster"
    num_nodes    = 1
    storage_type = "HDD"
    kms_key_name = "demo-cmek-key"
  }

  labels = {
    my-label = "prod-label"
  }
}