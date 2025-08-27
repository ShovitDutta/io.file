resource "google_pubsub_topic" "negative" {
  name         = "example-topic"
  kms_key_name = google_kms_crypto_key.crypto_key.id
}

resource "google_kms_crypto_key_iam_member" "crypto_key_iam" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-789@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "example-key"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
  name     = "example-keyring"
  location = "global"
}
