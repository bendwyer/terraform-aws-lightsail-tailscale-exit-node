terraform {
  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.0"
    }
  }
}

variable "tailscale_hostname" {
  type = string
}

variable "tailscale_tag" {
  type = string
}

data "tailscale_device" "test_instance" {
  hostname = var.tailscale_hostname
  wait_for = "60s"
}
