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

provider "aws" {
  alias  = "jp"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "tailscale" {}

module "de_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"
}

module "jp_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"
  providers = {
    aws = aws.jp
  }
  lightsail_region = "ap-northeast-1"
}

module "us_exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"

  providers = {
    aws = aws.us
  }
  lightsail_region = "us-east-1"
}
