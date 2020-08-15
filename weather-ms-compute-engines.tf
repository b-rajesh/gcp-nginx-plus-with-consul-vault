resource "google_compute_firewall" "microservice-firewall-rule" {
  depends_on  = [google_compute_subnetwork.microservice-subnet]
  name        = "${random_pet.pet-prefix.id}-microservice-fw-rule"
  network     = "${random_pet.pet-prefix.id}-${var.network}"
  description = "Allow access to port 3000 to only accessed from nginx plus api gateway."
  allow {
    protocol = "tcp"
    ports = [
      "3000",
    ]
  }
  source_tags = ["${random_pet.pet-prefix.id}-nginx-plus-api-gwy", var.consul_server_cluster_name]

  target_tags = [
    "${random_pet.pet-prefix.id}-microservices", //the firewall rule applies only to instances in the VPC network that have one of these tags, which would be for nginx instances through templates
  ]
}

resource "google_compute_instance_template" "weather-microservice-template" {
  depends_on = [google_compute_subnetwork.microservice-subnet, google_compute_instance_template.consul-server-template]
  name       = "${random_pet.pet-prefix.id}-weather-microservice-template"
  tags       = ["${random_pet.pet-prefix.id}-microservices"]

  labels = {
    environment = "dev"
  }
  machine_type   = var.machine_type
  can_ip_forward = false
  metadata = merge(
    {
      "${var.metadata_key_name_for_cluster_size}" = var.consul_client_cluster_size
    },
    var.custom_metadata,
  )

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.weather_api_image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.microservice-subnet.name
    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
    ]
  }
  /* 
  service_account {
    email = null
    scopes = concat(
      ["userinfo-email", "compute-ro", var.storage_access_scope],
      var.service_account_scopes,
    )
  }
*/
  metadata_startup_script = data.template_file.startup_consul_client_and_apis.rendered //file("${path.module}/weather-startup.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "weather-microservice-group-manager" {
  depends_on         = [google_compute_subnetwork.microservice-subnet, google_compute_instance_template.consul-server-template]
  name               = "${random_pet.pet-prefix.id}-weather-ms-instance-group-manager"
  base_instance_name = "weather-microservice"
  zone               = var.zones
  target_size        = var.weather-api-cluster-size
  version {
    instance_template = google_compute_instance_template.weather-microservice-template.id
  }
}