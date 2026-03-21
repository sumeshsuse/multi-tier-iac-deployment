variable "hcloud_token" {
  sensitive = true
}

variable "server_type" {}
variable "server_image" {}
variable "server_location" {}

variable "api_servers" {
  type = list(string)
}