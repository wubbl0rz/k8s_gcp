resource "google_compute_instance" "jump" {
  name         = "jump"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.internal.self_link
  }

  lifecycle {
    ignore_changes = [metadata["ssh-keys"]]
  }
}
