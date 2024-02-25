variable "lightsail_region" {
  description = "The Amazon Lightsail region to deploy to."
  default     = "eu-central-1"
  type        = string
}

variable "lightsail_availability_zone" {
  description = "The chosen availability zone for the Lightsail region."
  default     = "a"
  type        = string
}

variable "tailscale_exit_node_tag_names" {
  default = [
    "tag:exit"
  ]
  description = "Tailscale exit node tag names to associate with ephemeral key. Tag names must be be prefixed with 'tag:'"
  type        = set(string)
}
