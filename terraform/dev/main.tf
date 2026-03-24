terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }

  cloud {
    organization = "QVEST"

    workspaces {
      name = "multi-tier-dev"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "weather-key"
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "dev_firewall" {
  name = "dev-firewall"

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

module "api_servers" {
  source   = "../modules/servers"
  for_each = toset(var.api_servers)

  server_name     = each.value
  server_type     = var.server_type
  server_image    = var.server_image
  server_location = var.server_location

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.dev_firewall.id]
}

module "db_server" {
  source = "../modules/servers"

  server_name     = "dev-db-1"
  server_type     = var.server_type
  server_image    = var.server_image
  server_location = var.server_location

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.dev_firewall.id]
}

module "load_balancer" {
  source = "../modules/load_balancer"

  load_balancer_name = "dev-lb"
  location           = var.server_location
  destination_port   = 8080
  api_server_ids = {
    for name, server in module.api_servers : name => server.server_id
  }
}