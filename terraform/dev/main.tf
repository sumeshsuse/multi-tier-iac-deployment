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
  name       = "weather-key"
  public_key = var.ssh_public_key
}

# Firewall

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

# API

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

# DB

module "db_server" {
  source = "../modules/servers"

  server_name     = "dev-db-1"
  server_type     = var.server_type
  server_image    = var.server_image
  server_location = var.server_location

  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.dev_firewall.id]
}