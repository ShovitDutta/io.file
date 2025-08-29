resource "google_compute_interconnect_attachment" "positive2" {
  name                     = "test-interconnect-attachment"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  encryption               = "NONE"
}

resource "google_compute_router" "router" {
  name                          = "test-router"
  network                       = google_compute_network.network.name
  encrypted_interconnect_router = true
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "network" {
  name                    = "test-network"
  auto_create_subnetworks = false
}