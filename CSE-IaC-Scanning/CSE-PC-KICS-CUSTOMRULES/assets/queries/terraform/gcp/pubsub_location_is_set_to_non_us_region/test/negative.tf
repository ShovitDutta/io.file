resource "google_pubsub_topic" "negative" {
  name = "example-topic"

  message_storage_policy {
    allowed_persistence_regions = [
      "us-east1","us-west-1"
    ]
  }
}