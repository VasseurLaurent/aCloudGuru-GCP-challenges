
resource "google_storage_bucket" "logs-bucket" {
  name          = "laurent-logs"
  location      = "EU"
  force_destroy = true
}

# data "google_iam_policy" "writer" {
#   binding {
#     role = "roles/storage.objectCreator"
#     members = [
#       "serviceAccount:${google_service_account.account.email}",
#     ]
#   }
# }

# resource "google_storage_bucket_iam_policy" "policy" {
#   bucket      = google_storage_bucket.logs-bucket.name
#   policy_data = data.google_iam_policy.writer.policy_data
# }

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

  #   metadata_startup_script = file("script.sh")

  metadata = {
    ssh-keys        = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX laurentvasseur@gmail.com"
    lab-logs-bucket = google_storage_bucket.logs-bucket.name
  }

  #   metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.account.email
    scopes = ["cloud-platform"]
  }
  depends_on = [
    google_storage_bucket.logs-bucket
  ]
}
