variable "digitalocean_token" {
  type        = string
  description = "DigitalOcean personal access token."
}

variable "digitalocean_region" {
  type        = string
  description = "Region for deploying resources."
  default     = "ams3"
}
