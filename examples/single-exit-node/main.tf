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
    time = {
      source  = "hashicorp/time"
      version = "~> 0.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "tailscale" {}

module "exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"
}
