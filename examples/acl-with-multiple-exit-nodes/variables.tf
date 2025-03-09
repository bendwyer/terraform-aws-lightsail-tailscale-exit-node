variable "lightsail_region" {
  description = "AWS Lightsail region to deploy to."
  default     = "eu-central-1"
  type        = string
}

variable "tailscale_exit_node_tag" {
  default     = "tag:exit"
  description = "Tailscale exit node tag to associate with machine(s). Tag must be be prefixed with 'tag:'"
  type        = string
}
