
resource "google_storage_bucket" "logs-bucket" {
  name          = "laurent-logs"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.logs-bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.account.email}"
}

resource "google_service_account" "account" {
  account_id   = "virtual-machine-account-id"
  display_name = "Virtual machine service acocunt"
}

resource "google_compute_instance" "machine" {
  name         = "machine"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"

  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("script.sh")

  metadata = {
    ssh-keys        = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
    lab-logs-bucket = "gs://${google_storage_bucket.logs-bucket.name}"
  }

  service_account {
    email  = google_service_account.account.email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    google_storage_bucket.logs-bucket,
    google_storage_bucket_iam_member.member
  ]
}
