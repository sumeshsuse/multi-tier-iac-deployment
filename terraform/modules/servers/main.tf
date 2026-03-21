resource "hcloud_server" "server_node" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  location    = var.server_location

  ssh_keys     = var.ssh_keys
  firewall_ids = var.firewall_ids

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}