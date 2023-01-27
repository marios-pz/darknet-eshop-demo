provider "google" {
    project = var.project["name"]
    credentials = file(var.project["creds"])
    region = var.region
    zone = var.zone
}

data "google_compute_image" "my_image" {
  family  = "cos-stable"
  project = "cos-cloud"
}

resource "google_compute_instance" "my_instance" {
    name = var.project["name"]
    machine_type = var.project["machine_type"]
    zone = var.zone
    allow_stopping_for_update = true 

    boot_disk {
            initialize_params {
                image = data.google_compute_image.my_image.self_link
            }
    }

    network_interface {
            network = google_compute_network.terraform-network.self_link
            subnetwork = google_compute_subnetwork.terraform-subnet.self_link
            access_config {
                //
            }
    }
}

resource "google_compute_network" "terraform-network" {
    name = var.network_name
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "terraform-subnet" {
        name  = var.network_subnet
        ip_cidr_range = var.network_cidr
        region = var.region
        network = google_compute_network.terraform-network.id
}
