# ACL with multiple exit nodes

This example will deploy multiple Tailscale exit nodes on AWS Lightsail. The `eu-central-1` deployment uses default settings. The `ap-northeast-1` and `us-east-2` deployments override the default `lightsail_region` and `lightsail_region_friendly_name` settings.

It will also define basic Tailscale access controls and the `tag:exit` tag so they do not need to be manually defined beforehand.
