output "prod_server_ips" {
  value = {
    for name, server in module.api_servers : name => server.server_ip
  }
}

output "db_server_ip" {
  value = module.db_server.server_ip
}

output "prod_load_balancer_ip" {
  value = hcloud_load_balancer.prod_lb.ipv4
}