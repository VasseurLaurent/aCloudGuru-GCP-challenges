/**
* # Challenge
* 
* ## Objectives 
*  * Create new project : Not possible with Terraform without an organization
*  * Create GCE instance that runs the provided script : DONE
*  * System logs available in Stackdriver Logs : DONE
*  * New GCS bucket for resulting log files : DONE
*  * Log file appears in new bucket after instance finishes starting up : DONE
*  * NO need to ssh to instance : DONE
*
*  ## Comments
*  
*  * Dedicated service account to add security
*  * Rewrite script to deploy the new Ops agent instead of the legacy one
* -----------------------------------------------------------
*/

locals {
  region = "asia-south1-a"
  machine_name = "machine"
}

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

resource "google_project_iam_binding" "monitoring_editor_biding" {
  project = data.google_project.project.id
  role    = "roles/monitoring.editor"
  members = ["serviceAccount:${google_service_account.account.email}"]
}

resource "google_project_iam_binding" "instance_editor_biding" {
  project = data.google_project.project.id
  role    = "roles/compute.instanceAdmin"
  members = ["serviceAccount:${google_service_account.account.email}"]
}

resource "google_project_iam_binding" "service_account_biding" {
  project = data.google_project.project.id
  role    = "roles/iam.serviceAccountUser"
  members = ["serviceAccount:${google_service_account.account.email}"]
}


resource "google_compute_instance" "machine" {
  name         = local.machine_name
  machine_type = "f1-micro"
  zone         = local.region

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

  metadata_startup_script = data.template_file.script.rendered

  metadata = {
    ssh-keys        = "${data.google_client_openid_userinfo.me.email}:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2x+idXXoYXV41TB4kZ/bn9FurtXa3LIQr+shtsoME/ vasseur.laurent@outlook.com"
    lab-logs-bucket = "gs://${google_storage_bucket.logs-bucket.name}"
  }

  labels = {
    "env" = "test"
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