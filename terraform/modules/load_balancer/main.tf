resource "hcloud_load_balancer" "this" {
  name               = var.load_balancer_name
  load_balancer_type = "lb11"
  location           = var.location
}

resource "hcloud_load_balancer_service" "http" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "http"
  listen_port      = 80
  destination_port = var.destination_port

  health_check {
    protocol = "http"
    port     = var.destination_port
    interval = 15
    timeout  = 10
    retries  = 3

    http {
      path = "/health"
    }
  }
}

resource "hcloud_load_balancer_target" "api_targets" {
  for_each = var.api_server_ids

  type             = "server"
  load_balancer_id = hcloud_load_balancer.this.id
  server_id        = each.value
}