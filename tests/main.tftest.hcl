mock_provider "aws" {
}

mock_provider "tailscale" {
  mock_data "tailscale_device" {
    defaults = {
      tags = [
        "tag:exit"
      ]
    }
  }
}

variables {
  lightsail_region               = "eu-central-1"
  lightsail_region_friendly_name = "frankfurt"
  tailscale_oauth_client_id      = "fakeoauthid"
  tailscale_oauth_client_secret  = "fakeoauthsecret"
}

# Setup instance_prefix and timestamp
run "setup" {
  module {
    source = "./tests/setup"
  }
}

# Run terraform-aws-lightsail-tailscale-exit-node module
run "create" {
  variables {
    lightsail_instance_name = "${run.setup.instance_prefix}-vpn-${var.lightsail_region}"
    lightsail_tags = {
      "created" = "${run.setup.timestamp}"
    }
    tailscale_hostname = var.lightsail_region_friendly_name
  }

  # Check the instance name
  assert {
    condition     = aws_lightsail_instance.this.name == var.lightsail_instance_name
    error_message = "Invalid instance name."
  }

  # Check the instance tag
  assert {
    condition     = aws_lightsail_instance.this.tags["created"] == var.lightsail_tags["created"]
    error_message = "Invalid tag."
  }
}

# Validate Tailscale status
run "validate" {
  module {
    source = "./tests/final"
  }

  variables {
    tailscale_hostname = var.lightsail_region_friendly_name
    tailscale_tag      = "tag:exit"
  }

  # Check hostname in Tailscale dashboard
  assert {
    condition     = data.tailscale_device.test_instance.hostname == var.tailscale_hostname
    error_message = "Invalid Tailscale hostname."
  }

  # Check tag in Tailscale dashboard
  assert {
    condition     = sort(data.tailscale_device.test_instance.tags)[0] == var.tailscale_tag
    error_message = "Invalid Tailscale tag."
  }
}
