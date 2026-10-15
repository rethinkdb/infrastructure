variable "digitalocean_token" {
  type        = string
  description = "DigitalOcean personal access token."
}

variable "digitalocean_region" {
  type        = string
  description = "Region for deploying resources."
  default     = "ams3"
}

variable "private_github_runner_count" {
  type        = number
  description = "Number of self-hosted GitHub runners to create."
  default     = 0
}
