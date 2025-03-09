terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.0"
    }
  }
}

resource "random_pet" "instance_prefix" {
  length = 1
}

resource "time_static" "timestamp" {}

output "timestamp" {
  value = formatdate("YYYYMMDD-hhmmss", "${time_static.timestamp.rfc3339}")
}

output "instance_prefix" {
  value = random_pet.instance_prefix.id
}
