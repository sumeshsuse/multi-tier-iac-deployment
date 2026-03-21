variable "server_name" {
  description = "Name of the server"
  type        = string
}

variable "server_image" {
  description = "Image to use for the server"
  type        = string
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
}

variable "server_location" {
  description = "Hetzner location"
  type        = string
}

variable "ipv4_enabled" {
  description = "Enable IPv4"
  type        = bool
  default     = true
}

variable "ipv6_enabled" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}


variable "ssh_keys" {
  description = "SSH key IDs"
  type        = list(string)
}

variable "firewall_ids" {
  description = "Firewall IDs to attach to the server"
  type        = list(string)
}