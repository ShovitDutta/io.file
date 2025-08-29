resource "google_pubsub_topic" "positive" {
  name         = "example-topic"
  kms_key_name = google_kms_crypto_key.crypto_key_test.id
}

resource "google_kms_crypto_key_iam_member" "crypto_key_iam_test" {
  crypto_key_id = google_kms_crypto_key.crypto_key_test.id
  role          = "roles/cloudkms.viewer"
  member        = "serviceAccount:service-789@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key" "crypto_key_test" {
  name     = "example-key"
  key_ring = google_kms_key_ring.key_ring_test.id
}

resource "google_kms_key_ring" "key_ring_test" {
  name     = "example-keyring"
  location = "global"
}
