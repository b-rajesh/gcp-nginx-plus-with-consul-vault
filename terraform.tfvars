# GKE specific variables
prefix                     = "raj" //keep it within 3-5 letters as the code is also generating unique petname along with it.
project_id                 = ""
region                     = "australia-southeast1"
network                    = "gce-api-vpc"
gwy_subnet                 = "api-gwy-subnet"
machine_type               = "f1-micro"
gwy_subnet_cidr            = "10.10.0.0/24"
zones                      = "australia-southeast1-a"
microservice_subnet        = "microservice-subnet"
microservice_subnet_cidr   = "10.20.0.0/24"

nginx-plus-image-name      = "nginxplus-r22-consul-1-8-3"
weather_api_image          = "weather-api-v2"
f1_api_image               = "f1-api-v2"
hello_nginx_api_image      = "hello-nginxplus-api-v2"

consul-subnet              = "consul-server-subnet"
consul_server_cluster_name = "consul-server-microservice"
consul_server_source_image = "consul-server-v1-8-3"
consul_machine_type        = "n2-standard-2"
consul_subnet_cidr         = "10.30.0.0/24"