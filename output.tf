output "weather_api_url" {
  description = "Curl command to access weather API"
  value       = "curl http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/weather?city=melbourne"
}

output "hello-nginxplus_api_url" {
  description = "HTTPie command to access Hellow NGINX Plus API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/hello-nginxplus-api"
}

output "f1_api_url" {
  description = "HTTPie command to access F1 detail through API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/f1-api/f1/drivers.json"
}

output "nginxplus_dashboard_url" {
  description = "NGINX Plus dashboard App"
  value       = "http://${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/dashboard.html"
}

output "admin_api_url" {
  description = "HTTPie command to access Admin API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}:8080/api/6/http/upstreams"
}

output "inventory_api_url" {
  description = "HTTPie command to access Inventory API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/warehouse-api/inventory"
}

output "pricing_api_url" {
  description = "HTTPie command to access Pricing API"
  value       = "http ${google_compute_forwarding_rule.gce-ext-lb-80-forwarding-rule.ip_address}/warehouse-api/pricing"
}


output "gcp_project" {
  description = "The GCP Project where all resources are deployed."
  value       = var.project_id
}

output "gcp_region" {
  description = "The GCP region where all resources are deployed."
  value       = var.region
}

output "cluster_size" {
  description = "The number of servers in the Consul Server cluster."
  value       = var.consul_server_cluster_size
}

output "cluster_tag_name" {
  description = "The tag assigned to each Consul Server node that is used to discover other Consul Server nodes."
  value       = "${random_pet.pet-prefix.id}-consul-server"
}

output "instance_group_name" {
  description = "The name of the Managed Instance Group that contains the Consul Server cluster."
  value       = google_compute_instance_group_manager.consul-server-group-manager.name
}

output "instance_group_url" {
  value = google_compute_instance_group_manager.consul-server-group-manager.self_link
}

output "instance_template_url" {
  value = data.template_file.startup_consul_server.rendered
}

output "instance_template_name" {
  value = element(
    google_compute_instance_template.consul-server-template.*.name,
    0,
  )
}

output "instance_template_metadata_fingerprint" {
  value = element(
    google_compute_instance_template.consul-server-template.*.metadata_fingerprint,
    0,
  )
}

output "client_instance_group_name" {
  description = "The name of the Managed Instance Group that contains the Consul Client cluster."
  value       = ""
}
