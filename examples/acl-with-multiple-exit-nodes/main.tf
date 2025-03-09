terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.0"
    }
  }
}

provider "aws" {
  region = var.lightsail_region
}

provider "aws" {
  alias  = "jp"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "tailscale" {}

resource "tailscale_acl" "this" {
  acl = templatefile("${path.root}/acl.json.tftpl", {
    tailscale_exit_node_tag = var.tailscale_exit_node_tag
  })
  reset_acl_on_destroy = true
}

module "de_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"

  lightsail_instance_name = "vpn-${var.lightsail_region}"
}

module "jp_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"

  providers = {
    aws = aws.jp
  }
  lightsail_instance_name        = "vpn-ap-northeast-1"
  lightsail_region               = "ap-northeast-1"
  lightsail_region_friendly_name = "tokyo"
}

module "us_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"

  providers = {
    aws = aws.us
  }

  lightsail_instance_name        = "vpn-us-east-1"
  lightsail_region               = "us-east-1"
  lightsail_region_friendly_name = "ohio"
}
