/**
 * # terraform-aws-lightsail-tailscale-exit-node
 *
 * Terraform module for deploying a Tailscale exit node on AWS Lightsail.
 *
 * > [!WARNING]\
 * > This module requires a tag defined in Tailscale access controls.
 *
 */

resource "time_static" "this" {}

resource "aws_lightsail_instance" "this" {
  name              = "vpn-${var.lightsail_region}-${formatdate("YYYYMMDDhhmmss", "${time_static.this.rfc3339}")}"
  availability_zone = "${var.lightsail_region}${var.lightsail_availability_zone}"
  blueprint_id      = "amazon_linux_2023"
  bundle_id         = "nano_3_0"
  user_data = templatefile("${path.module}/userdata.sh.tftpl", {
    tailscale_preauth_key = tailscale_tailnet_key.this.key
    tailscale_hostname    = "${var.lightsail_region}-${formatdate("YYYYMMDDhhmmss", "${time_static.this.rfc3339}")}"
  })
  ip_address_type = "dualstack"
}

resource "aws_lightsail_instance_public_ports" "this" {
  instance_name = aws_lightsail_instance.this.name

  port_info {
    cidr_list_aliases = []
    cidrs = [
      "0.0.0.0/0"
    ]
    ipv6_cidrs = [
      "::/0"
    ]
    protocol  = "udp"
    from_port = 41641
    to_port   = 41641
  }
}

resource "tailscale_tailnet_key" "this" {
  description         = "preauth-ephemeral-exit"
  expiry              = 7776000
  ephemeral           = true
  preauthorized       = true
  recreate_if_invalid = "always"
  reusable            = true
  tags                = var.tailscale_exit_node_tag_names
}
