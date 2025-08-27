terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.15.0"
    }
  }
}

provider "google" {
  project = "security-controls-sandbox"
  region  = "us-central1"
  zone    = "us-central1-c"
}