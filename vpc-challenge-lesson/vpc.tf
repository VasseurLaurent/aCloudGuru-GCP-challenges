resource "google_compute_network" "vpc" {
  name                    = "challenge-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "public1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-east1"
  network       = google_compute_network.vpc.id
}


resource "google_compute_subnetwork" "private" {
  name          = "private1"
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-east2"
  network       = google_compute_network.vpc.id
}


resource "google_compute_router" "router-public" {
  name    = "router-public"
  region  = google_compute_subnetwork.public.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router" "router-private" {
  name    = "router-private"
  region  = google_compute_subnetwork.private.region
  network = google_compute_network.vpc.id
}


resource "google_compute_router_nat" "nat-public" {
  name                               = "nat-public"
  router                             = google_compute_router.router-public.name
  region                             = google_compute_router.router-public.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_router_nat" "nat-private" {
  name                               = "nat-private"
  router                             = google_compute_router.router-private.name
  region                             = google_compute_router.router-private.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


# Rules to allow network connection of jumpstation

resource "google_compute_firewall" "allow-ssh-to-jumpstation-from-outside" {
  name    = "allowsshtojumpstationfromoutside"
  network = google_compute_network.vpc.name

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  target_tags   = ["jumpstation"]
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "allow-ssh-from-jumpstation" {
  name    = "allowsshfromjumpstation"
  network = google_compute_network.vpc.name

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  target_tags        = ["jumpstation"]
  direction          = "EGRESS"
  destination_ranges = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "google_compute_firewall" "allow-ssh-from-jumpstation-ingress" {
  name    = "allowsshfromjumpstationingress"
  network = google_compute_network.vpc.name

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction   = "INGRESS"
  source_tags = ["jumpstation"]
}


# Rules to allow connection to frontend from outside 



resource "google_compute_firewall" "frontend-ingress" {
  name    = "frontendingress"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags   = ["frontend"]
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
}

# Allow internet access

resource "google_compute_firewall" "internet-access-from-machines" {
  name    = "internetaccessfrommachines"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]

  }
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}


# Ping between machines

resource "google_compute_firewall" "internet-ping-from-machines" {
  name    = "internetpingfrommachines"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"

  }

  direction = "EGRESS"
}

resource "google_compute_firewall" "internet-ping-from-machines-ingress" {
  name    = "internetpingfrommachinesingress"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"

  }
  direction     = "INGRESS"
  source_ranges = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Allow port 80-443 from frontend to backend

resource "google_compute_firewall" "allowfrontendtobackend" {
  name    = "allowfrontendtobackend"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  direction   = "INGRESS"
  source_tags = ["frontend"]
  target_tags = ["backend"]

}
