variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "location" {
  description = "Hetzner location"
  type        = string
}

variable "destination_port" {
  description = "Port on backend servers"
  type        = number
}

variable "api_server_ids" {
  description = "Map of API server names to server IDs"
  type        = map(number)
}