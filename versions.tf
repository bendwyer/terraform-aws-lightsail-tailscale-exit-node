terraform {
  required_version = ">=1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.37.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = ">=0.13.13"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.10.0"
    }
  }
}