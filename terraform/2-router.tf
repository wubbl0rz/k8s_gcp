resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = google_compute_network.default.self_link
}
