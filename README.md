# terraform-aws-lightsail-tailscale-exit-node

Terraform module for deploying a Tailscale exit node on AWS Lightsail.

> [!WARNING]\
> - This module requires a tag defined in Tailscale Access Controls.
> - This module requires an OAuth client with at least the following scopes: devices:core write, keys:auth-keys write

## Usage

### Single exit node

```hcl
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.lightsail_region
}

module "exit_node" {
  source = "github.com/bendwyer/terraform-aws-lightsail-tailscale-exit-node"

  lightsail_instance_name = "vpn-${var.lightsail_region}"
}
```

### Multiple exit nodes

```hcl
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
```

### ACL with multiple exit nodes

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.37.0 |



## Resources

| Name | Type |
|------|------|
| [aws_lightsail_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance) | resource |
| [aws_lightsail_instance_public_ports.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance_public_ports) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lightsail_instance_name"></a> [lightsail\_instance\_name](#input\_lightsail\_instance\_name) | Display name for instance in Lightsail dashboard. | `string` | n/a | yes |
| <a name="input_tailscale_hostname"></a> [tailscale\_hostname](#input\_tailscale\_hostname) | Display name for instance in Tailscale dashboard | `string` | n/a | yes |
| <a name="input_tailscale_oauth_client_id"></a> [tailscale\_oauth\_client\_id](#input\_tailscale\_oauth\_client\_id) | Tailscale OAuth client ID. | `string` | n/a | yes |
| <a name="input_tailscale_oauth_client_secret"></a> [tailscale\_oauth\_client\_secret](#input\_tailscale\_oauth\_client\_secret) | Tailscale OAuth client secret. | `string` | n/a | yes |
| <a name="input_lightsail_availability_zone"></a> [lightsail\_availability\_zone](#input\_lightsail\_availability\_zone) | AWS Lightsail availability zone for AWS Lightsail region. | `string` | `"a"` | no |
| <a name="input_lightsail_bundle_id"></a> [lightsail\_bundle\_id](#input\_lightsail\_bundle\_id) | AWS Lightsail bundle ID. Determines type of instance to deploy. | `string` | `"nano_3_0"` | no |
| <a name="input_lightsail_region"></a> [lightsail\_region](#input\_lightsail\_region) | AWS Lightsail region to deploy to. | `string` | `"eu-central-1"` | no |
| <a name="input_lightsail_region_friendly_name"></a> [lightsail\_region\_friendly\_name](#input\_lightsail\_region\_friendly\_name) | Friendly name for AWS Lightsail region to deploy to. | `string` | `"frankfurt"` | no |
| <a name="input_lightsail_tags"></a> [lightsail\_tags](#input\_lightsail\_tags) | A map of key-value pairs used to create AWS Lightsail instance tags. By default no tags will be created. | `map(string)` | `null` | no |
| <a name="input_tailscale_exit_node_tag"></a> [tailscale\_exit\_node\_tag](#input\_tailscale\_exit\_node\_tag) | Tailscale exit node tag to associate with machine(s). Tag must be be prefixed with 'tag:' | `string` | `"tag:exit"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | AWS Lightsail instance public IP address. |

