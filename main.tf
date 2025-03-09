/**
 * # terraform-aws-lightsail-tailscale-exit-node
 *
 * Terraform module for deploying a Tailscale exit node on AWS Lightsail.
 *
 * > [!WARNING]\
 * > This module requires a tag defined in Tailscale Access Controls.
 * > This module requires an OAuth client with at least the following scopes: devices:core write, keys:auth-keys write
 *
 */

resource "aws_lightsail_instance" "this" {
  name              = var.lightsail_instance_name
  availability_zone = "${var.lightsail_region}${var.lightsail_availability_zone}"
  blueprint_id      = "amazon_linux_2023"
  bundle_id         = var.lightsail_bundle_id
  user_data = templatefile("${path.module}/userdata.sh.tftpl", {
    tailscale_exit_node_tag       = var.tailscale_exit_node_tag
    tailscale_hostname            = var.tailscale_hostname
    tailscale_oauth_client_id     = var.tailscale_oauth_client_id
    tailscale_oauth_client_secret = var.tailscale_oauth_client_secret
  })
  ip_address_type = "dualstack"
  tags            = var.lightsail_tags
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

  lifecycle {
    replace_triggered_by = [
      aws_lightsail_instance.this
    ]
  }
}
