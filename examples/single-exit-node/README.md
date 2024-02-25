# Single exit node

This example will deploy a single Tailscale exit node on AWS Lightsail with all default settings:
  - `eu-central-1a` region and availability zone
  - `tag:exit` Tailscale tag

> [!WARNING]\
> This example assumes that `tag:exit` is already defined in the Tailscale access controls. See [Defining a tag](https://tailscale.com/kb/1068/acl-tags#defining-a-tag) for more information.

