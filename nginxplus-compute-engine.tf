resource "google_compute_instance_template" "nginx-plus-gwy-template" {
  depends_on = [google_compute_instance_template.consul-server-template]
  name       = "${random_pet.pet-prefix.id}-nginx-plus-gwy-template"
  tags       = ["${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]

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

  // Create a new boot disk from an image
  disk {
    source_image = var.nginx-plus-image-name
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
    ]
  }
  metadata_startup_script = data.template_file.startup_consul_client.rendered //metadata_startup_script = file("${path.module}/add-upstream-nginx.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "nginx-plus-gwy-group-manager" {
  depends_on         = [google_compute_instance_template.consul-server-template]
  name               = "${random_pet.pet-prefix.id}-nginx-plus-gwy-instance-group-manager"
  base_instance_name = "nginx-plus-api-gwy"
  zone               = var.zones
  target_size        = var.nginx-plus-cluster-size
  target_pools       = [google_compute_target_pool.default.id]
  version {
    instance_template = google_compute_instance_template.nginx-plus-gwy-template.id
  }
}

resource "google_compute_firewall" "nginx-plus-firewall-rule" {
  depends_on  = [google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule, google_compute_forwarding_rule.gce-ext-lb-8080-forwarding-rule]
  name        = "${random_pet.pet-prefix.id}-nginx-plus-fw-rule"
  network     = "${random_pet.pet-prefix.id}-${var.network}"
  description = "Allow access to ports 22,80,443 and 8080 on all NGINX plus instances."
  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
      "8080",
    ]
  }
  //source_tags = ["nginx-plus-api-gwy"]

  target_tags = [
    "${random_pet.pet-prefix.id}-nginx-plus-api-gwy", //the firewall rule applies only to instances in the VPC network that have one of these tags, which would be for nginx instances through templates
  ]
}

data "template_file" "startup_consul_client" {
  template = "${file("${path.module}/startup-consul-client.sh")}"
  vars = {
    cluster_tag_name = var.consul_server_cluster_name
  }
}

