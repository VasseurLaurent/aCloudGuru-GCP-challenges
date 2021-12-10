
resource "google_service_account" "sa-front" {
  account_id   = "frontend"
  display_name = "Frontend service account"
}

resource "google_compute_instance_template" "template-front" {
  name         = "frontend"
  machine_type = "f1-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    disk_size_gb = 10
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.public.id
  }

  metadata = {
    ssh-keys = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
  }
  can_ip_forward = false

  service_account {
    email  = google_service_account.sa-front.email
    scopes = ["cloud-platform"]
  }

  tags = ["frontend"]
}


resource "google_service_account" "sa-backend" {
  account_id   = "backend"
  display_name = "Backend service account"
}

resource "google_compute_instance_template" "template-back" {
  name         = "backend"
  machine_type = "f1-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    disk_size_gb = 10
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.private.id
  }

  metadata = {
    ssh-keys = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
  }
  can_ip_forward = false

  service_account {
    email  = google_service_account.sa-backend.email
    scopes = ["cloud-platform"]
  }

  tags = ["backend"]
}
