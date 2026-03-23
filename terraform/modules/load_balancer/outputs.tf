output "load_balancer_ip" {
  description = "Public IPv4 of the load balancer"
  value       = hcloud_load_balancer.this.ipv4
}

output "load_balancer_id" {
  description = "Hetzner load balancer ID"
  value       = hcloud_load_balancer.this.id
}