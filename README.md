# terraform-aws-lightsail-tailscale-exit-node

Terraform module for deploying a Tailscale exit node on AWS Lightsail.

> [!WARNING]\
> This module requires a tag defined in Tailscale access controls.

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

resource "tailscale_acl" "this" {
  acl = templatefile("${path.root}/acl.json.tftpl", {
    tailscale_exit_node_tag_name = "exit"
  })
}

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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.37.0 |
| <a name="requirement_tailscale"></a> [tailscale](#requirement\_tailscale) | >=0.13.13 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.37.0 |
| <a name="provider_tailscale"></a> [tailscale](#provider\_tailscale) | >=0.13.13 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.10.0 |



## Resources

| Name | Type |
|------|------|
| [aws_lightsail_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance) | resource |
| [aws_lightsail_instance_public_ports.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance_public_ports) | resource |
| [tailscale_tailnet_key.this](https://registry.terraform.io/providers/tailscale/tailscale/latest/docs/resources/tailnet_key) | resource |
| [time_static.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lightsail_availability_zone"></a> [lightsail\_availability\_zone](#input\_lightsail\_availability\_zone) | AWS Lightsail availability zone for the AWS Lightsail region. | `string` | `"a"` | no |
| <a name="input_lightsail_region"></a> [lightsail\_region](#input\_lightsail\_region) | AWS Lightsail region to deploy to. | `string` | `"eu-central-1"` | no |
| <a name="input_tailscale_exit_node_tag_names"></a> [tailscale\_exit\_node\_tag\_names](#input\_tailscale\_exit\_node\_tag\_names) | Tailscale exit node tag names to associate with ephemeral key. Tag names must be be prefixed with 'tag:' | `set(string)` | <pre>[<br/>  "tag:exit"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | AWS Lightsail instance public IP address. |

