resource "google_compute_network" "default" {
  name                            = "default"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

resource "google_compute_subnetwork" "internal" {
  name                     = "internal"
  ip_cidr_range            = "10.0.0.0/24" // 10.0.0.1 - 10.0.0.254
  region                   = var.region
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = "10.2.0.0/16"
  }
}
