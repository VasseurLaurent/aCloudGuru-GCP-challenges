
resource "google_storage_bucket" "bucket" {
  name          = "laurentlab"
  location      = "ASIA"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_service_account" "sa-reader" {
  account_id   = "virtual-machine-account-reader"
  display_name = "Virtual machine service account"
}

resource "google_service_account" "sa-writer" {
  account_id   = "virtual-machine-account-writer"
  display_name = "Virtual machine service account"
}

resource "google_project_iam_binding" "binding-writer" {
  project = data.google_project.project.id
  role    = "roles/storage.objectCreator"
  members = [ "serviceAccount:${google_service_account.sa-writer.email}" ]
  condition {
    title = "Specify bucket"
    expression = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.bucket.name}\")"
  }
}

resource "google_project_iam_binding" "binding-reader" {
  project = data.google_project.project.id
  role    = "roles/storage.objectViewer"
  members = [ "serviceAccount:${google_service_account.sa-reader.email}" ]
  condition {
    title = "Specify bucket"
    expression = "resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.bucket.name}\")"
  }
}



resource "google_compute_instance" "machine-reader" {
  name         = "reader"
  machine_type = "f1-micro"
  zone         = "asia-south1-a"

  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-10-buster-v20211105"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys        = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
  }

  labels = {
    "env" = "test"
  }

  service_account {
    email  = google_service_account.sa-reader.email
    scopes = ["cloud-platform"]
  }
}


resource "google_compute_instance" "machine-writer" {
  name         = "writer"
  machine_type = "f1-micro"
  zone         = "asia-south1-a"

  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-10-buster-v20211105"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys  = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
  }

  labels = {
    "env" = "test"
  }

  service_account {
    email  = google_service_account.sa-writer.email
    scopes = ["cloud-platform"]
  }
}