resource "google_pubsub_topic" "positive1" {
  name = "example-topic"

  message_storage_policy {
    allowed_persistence_regions = [
      "europe-west3","us-east1",
    ]
  }
}