variable "lightsail_availability_zone" {
  description = "AWS Lightsail availability zone for AWS Lightsail region."
  default     = "a"
  type        = string
}

variable "lightsail_bundle_id" {
  description = "AWS Lightsail bundle ID. Determines type of instance to deploy."
  default     = "nano_3_0"
  type        = string
}

variable "lightsail_instance_name" {
  description = "Display name for instance in Lightsail dashboard."
  type        = string
}
variable "lightsail_region" {
  description = "AWS Lightsail region to deploy to."
  default     = "eu-central-1"
  type        = string
}

variable "lightsail_region_friendly_name" {
  description = "Friendly name for AWS Lightsail region to deploy to."
  default     = "frankfurt"
  type        = string
}

variable "lightsail_tags" {
  description = "A map of key-value pairs used to create AWS Lightsail instance tags. By default no tags will be created."
  default     = null
  type        = map(string)
}

variable "tailscale_exit_node_tag" {
  default     = "tag:exit"
  description = "Tailscale exit node tag to associate with machine(s). Tag must be be prefixed with 'tag:'"
  type        = string
}

variable "tailscale_hostname" {
  description = "Display name for instance in Tailscale dashboard"
  type        = string
}

variable "tailscale_oauth_client_id" {
  description = "Tailscale OAuth client ID."
  type        = string
}

variable "tailscale_oauth_client_secret" {
  description = "Tailscale OAuth client secret."
  type        = string
  sensitive   = true
}
