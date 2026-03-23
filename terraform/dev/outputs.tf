output "dev_server_ips" {
  value = {
    for name, server in module.api_servers : name => server.server_ip
  }
}

output "db_server_ip" {
  value = module.db_server.server_ip
}

output "dev_load_balancer_ip" {
  value = module.load_balancer.load_balancer_ip
}