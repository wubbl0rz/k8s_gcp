resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-all" {
  name    = "allow-all"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
}
