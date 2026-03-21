output "server_ip" {
description = "Public IPv4 of server"
value       = hcloud_server.server_node.ipv4_address
}


output "server_id" {
  description = "Hetzner server ID"
  value       = hcloud_server.server_node.id
}