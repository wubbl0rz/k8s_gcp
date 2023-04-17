resource "google_container_node_pool" "pool" {
  name       = "pool"
  cluster    = google_container_cluster.primary.id
  node_count = 3

  node_config {
    disk_size_gb    = 40
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    machine_type = "e2-small"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
