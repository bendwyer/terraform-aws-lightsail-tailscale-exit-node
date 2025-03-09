# Multiple exit nodes

This example will deploy multiple Tailscale exit nodes on AWS Lightsail. The `eu-central-1` deployment uses default settings. The `ap-northeast-1` and `us-east-2` deployments override the default `lightsail_region` and `lightsail_region_friendly_name` settings.

> [!WARNING]\
> This example assumes that `tag:exit` is already defined in the Tailscale access controls. See [Defining a tag](https://tailscale.com/kb/1068/acl-tags#defining-a-tag) for more information.
