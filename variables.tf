variable "network" {}
variable "gwy_subnet" {}
variable "project_id" {}
variable "region" {}
variable "gwy_subnet_cidr" {}
variable "machine_type" {}
variable "f1_api_image" {}
variable "hello_nginx_api_image" {}
variable "consul-subnet" {}
variable "prefix" {
  description = "A prefix used for all resources in this example - keep it within 3-5 letters"
}
variable "nginx-plus-image-name" {
  description = "Assuming you would have run the packer to build the image, you could override this in terraform.tfvars"
  default     = "nginxplus-r22"
}
variable "weather_api_image" {
  description = "Assuming you would have run the packer to build the image, you could override this in terraform.tfvars"
  default     = "weather-api-v1"
}
variable "zones" {}
variable "microservice_subnet" {}
variable "microservice_subnet_cidr" {}
variable "consul_subnet_cidr" {}
variable "protocol" {
  description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "ip_address" {
  description = "IP address of the load balancer. If empty, an IP address will be automatically assigned."
  type        = string
  default     = null
}

variable "port_range" {
  description = "Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
  type        = string
  default     = null
}

variable "enable_health_check" {
  description = "Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
  type        = bool
  default     = false
}

variable "health_check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
  default     = 8080
}

variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "How often (in seconds) to send a health check. Default is 5."
  type        = number
  default     = 5
}

variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "The request path of the HTTP health check request. The default value is '/api'."
  type        = string
  default     = "/api"
}
variable "consul_machine_type" {}
variable "consul_server_cluster_name" {
  description = "The name of the Consul Server cluster. All resources will be namespaced by this value. E.g. consul-server-prod"
  type        = string
}

variable "consul_server_cluster_size" {
  description = "The number of nodes to have in the Consul Server cluster. We strongly recommended that you use either 3 or 5."
  type        = number
  default     = 3
}
variable "custom_metadata" {
  description = "A map of metadata key value pairs to assign to the Compute Instance metadata."
  type        = map(string)
  default     = {}
}

variable "consul_server_source_image" {
  description = "The Google Image used to launch each node in the Consul Server cluster."
  type        = string
}

# Firewall Ports

variable "server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  type        = number
  default     = 8300
}

variable "cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  type        = number
  default     = 8400
}

variable "serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  type        = number
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  type        = number
  default     = 8302
}

variable "http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  type        = number
  default     = 8500
}

variable "dns_port" {
  description = "The port used to resolve DNS queries."
  type        = number
  default     = 8600
}

variable "consul_client_cluster_size" {
  description = "The number of nodes to have in the Consul Client example cluster. Any number of nodes is permissible, though 3 is usually enough to test.."
  type        = number
  default     = 3
}

variable "metadata_key_name_for_cluster_size" {
  description = "The key name to be used for the custom metadata attribute that represents the size of the Consul cluster."
  type        = string
  default     = "cluster-size"
}

variable "service_account_scopes" {
  description = "A list of service account scopes that will be added to the Compute Instance Template in addition to the scopes automatically added by this module."
  type        = list(string)
  default     = []
}

variable "storage_access_scope" {
  description = "Used to set the access permissions for Google Cloud Storage. As of September 2018, this must be one of ['', 'storage-ro', 'storage-rw', 'storage-full']"
  type        = string
  default     = "storage-ro"
}

# Disk Settings

variable "root_volume_disk_size_gb" {
  description = "The size, in GB, of the root disk volume on each Consul node."
  type        = number
  default     = 30
}

variable "root_volume_disk_type" {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
  default     = "pd-standard"
}


variable "allowed_inbound_cidr_blocks_http_api" {
  description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow API connections to Consul."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_inbound_tags_http_api" {
  description = "A list of tags from which the Compute Instances will allow API connections to Consul."
  type        = list(string)
  default     = []
}

variable "allowed_inbound_cidr_blocks_dns" {
  description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_inbound_tags_dns" {
  description = "A list of tags from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
  type        = list(string)
  default     = []
}

variable "consul_server_allowed_inbound_cidr_blocks_http_api" {
  description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow API connections to Consul."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "consul_server_allowed_inbound_cidr_blocks_dns" {
  description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

