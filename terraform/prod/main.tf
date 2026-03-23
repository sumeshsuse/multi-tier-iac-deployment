terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "prod-weather-key"
  public_key = var.ssh_public_key
}

# Firewall

resource "hcloud_firewall" "prod_firewall" {
  name = "prod-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8080"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# API Servers

module "api_servers" {
  source   = "../modules/servers"
  for_each = toset(var.api_servers)

  server_name     = each.value
  server_type     = var.server_type
  server_image    = var.server_image
  server_location = var.server_location

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.prod_firewall.id]
}

# DB Server

module "db_server" {
  source = "../modules/servers"

  server_name     = "prod-db-1"
  server_type     = var.server_type
  server_image    = var.server_image
  server_location = var.server_location

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.prod_firewall.id]
}

# Load Balancer

resource "hcloud_load_balancer" "prod_lb" {
  name               = "prod-lb"
  load_balancer_type = "lb11"
  location           = var.server_location
}

resource "hcloud_load_balancer_service" "prod_http" {
  load_balancer_id = hcloud_load_balancer.prod_lb.id
  protocol         = "http"
  listen_port      = 80
  destination_port = 8080

  health_check {
    protocol = "http"
    port     = 8080
    interval = 15
    timeout  = 10
    retries  = 3

    http {
      path = "/health"
    }
  }
}

resource "hcloud_load_balancer_target" "api_1" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.prod_lb.id
  server_id        = module.api_servers["prod-api-1"].server_id
}

resource "hcloud_load_balancer_target" "api_2" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.prod_lb.id
  server_id        = module.api_servers["prod-api-2"].server_id
}

resource "hcloud_load_balancer_target" "api_3" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.prod_lb.id
  server_id        = module.api_servers["prod-api-3"].server_id
}