# ACL with multiple exit nodes

This example will deploy multiple Tailscale exit nodes on AWS Lightsail with the following default settings:
  - `tag:exit` Tailscale tag

It will also define basic Tailscale access controls and the `tag:exit` tag so they do not need to be manually defined beforehand.
