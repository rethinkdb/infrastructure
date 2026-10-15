variable "name" {
  type        = string
  description = "Droplet name."
}

variable "region" {
  type        = string
  description = "DigitalOcean region for the droplet."
}

variable "size" {
  type        = string
  description = "Droplet size slug."
}

variable "image" {
  type        = string
  description = "Droplet image slug."
  default     = "ubuntu-24-04-x64"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH key fingerprints or IDs to install on the droplet."
  default     = []
}

variable "droplet_agent" {
  type        = bool
  description = "Install the DigitalOcean agent used for metrics and recovery."
  default     = true
}

variable "monitoring" {
  type        = bool
  description = "Enable DigitalOcean monitoring."
  default     = true
}

variable "backups" {
  type        = bool
  description = "Enable droplet backups."
  default     = false
}

variable "backup_policy" {
  type = object({
    plan    = string
    weekday = optional(string)
    hour    = optional(number)
  })
  description = "Backup schedule. Used only when backups are enabled."
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Extra droplet tags. terraform-managed is always added."
  default     = []
}

variable "volumes" {
  type = map(object({
    size                    = number
    name                    = optional(string)
    description             = optional(string)
    initial_filesystem_type = optional(string, "ext4")
    tags                    = optional(list(string))
  }))
  description = "Block storage volumes to create and attach. The map key is the volume name when name is omitted. Tags default to the droplet tags."
  default     = {}
}

variable "firewall" {
  type = object({
    name = optional(string)
    inbound_rules = optional(list(object({
      protocol                  = string
      port_range                = optional(string)
      source_addresses          = optional(list(string))
      source_droplet_ids        = optional(list(string))
      source_tags               = optional(list(string))
      source_load_balancer_uids = optional(list(string))
    })), [])
    outbound_rules = optional(list(object({
      protocol                       = string
      port_range                     = optional(string)
      destination_addresses          = optional(list(string))
      destination_droplet_ids        = optional(list(string))
      destination_tags               = optional(list(string))
      destination_load_balancer_uids = optional(list(string))
    })), [])
  })
  description = "Cloud firewall attached to this droplet. Null skips firewall creation. Name defaults to the droplet name plus -firewall."
  default     = null

  validation {
    condition     = var.firewall == null || length(var.firewall.inbound_rules) + length(var.firewall.outbound_rules) > 0
    error_message = "A firewall must include at least one inbound or outbound rule."
  }
}
