resource "google_compute_target_pool" "target-front" {
  name   = "target-front"
  region = "asia-east1"
}

resource "google_compute_region_instance_group_manager" "manager-front" {
  name               = "manager-front"
  base_instance_name = "front"
  region             = "asia-east1"

  version {
    name              = "frontend"
    instance_template = google_compute_instance_template.template-front.id
  }

  target_pools = [google_compute_target_pool.target-front.id]
}

resource "google_compute_region_autoscaler" "autoscaler-front" {
  name   = "autoscaler-front"
  region = "asia-east1"
  target = google_compute_region_instance_group_manager.manager-front.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_target_pool" "target-back" {
  name   = "target-back"
  region = "asia-east2"
}

resource "google_compute_region_instance_group_manager" "manager-back" {
  name               = "manager-back"
  base_instance_name = "back"
  region             = "asia-east2"

  version {
    name              = "backend"
    instance_template = google_compute_instance_template.template-back.id
  }

  target_pools = [google_compute_target_pool.target-back.id]
}

resource "google_compute_region_autoscaler" "autoscaler-back" {
  name   = "autoscaler-back"
  region = "asia-east2"
  target = google_compute_region_instance_group_manager.manager-back.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}
