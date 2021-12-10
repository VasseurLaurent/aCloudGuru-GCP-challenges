
resource "google_compute_instance" "machine" {
  name         = "jumpstation"
  machine_type = "f1-micro"
  zone         = "asia-east1-a"

  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.public.id
    access_config {
      // Ephemeral public IP
    }
  }
  tags = ["jumpstation"]
  metadata = {
    ssh-keys = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
  }

}
