resource "google_pubsub_topic" "positive2" {
  name = "example-topic"

  message_storage_policy {
    allowed_persistence_regions = [
      "europe-west1",
    ]
  }
}