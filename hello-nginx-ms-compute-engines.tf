resource "google_compute_instance_template" "hello-nginx-microservice-template" {
  depends_on = [google_compute_subnetwork.microservice-subnet, google_compute_instance_template.consul-server-template]
  name       = "${random_pet.pet-prefix.id}-hello-nginx-microservice-template"
  tags       = ["${random_pet.pet-prefix.id}-microservices"] #One firewall rule to let nginxplus to talk to the services deployed in the microservice subnet

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
    source_image = var.hello_nginx_api_image
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
  metadata_startup_script = data.template_file.startup_consul_client_and_apis.rendered //file("${path.module}/startup.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "hello-nginx-microservice-group-manager" {
  depends_on         = [google_compute_subnetwork.microservice-subnet, google_compute_instance_template.consul-server-template]
  name               = "${random_pet.pet-prefix.id}-hello-nginx-ms-instance-group-manager"
  base_instance_name = "hello-nginx-microservice"
  zone               = var.zones
  target_size        = var.hello-nginx_-pi-cluster-size
  version {
    instance_template = google_compute_instance_template.hello-nginx-microservice-template.id
  }
}
