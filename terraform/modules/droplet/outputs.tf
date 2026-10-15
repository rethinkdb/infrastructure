output "id" {
  value       = digitalocean_droplet.this.id
  description = "Droplet ID."
}

output "name" {
  value       = digitalocean_droplet.this.name
  description = "Droplet name."
}

output "ipv4_address" {
  value       = digitalocean_droplet.this.ipv4_address
  description = "Public IPv4 address."
}

output "ipv4_address_private" {
  value       = digitalocean_droplet.this.ipv4_address_private
  description = "Private IPv4 address."
}

output "urn" {
  value       = digitalocean_droplet.this.urn
  description = "Droplet uniform resource name."
}

output "volume_ids" {
  value       = { for key, volume in digitalocean_volume.this : key => volume.id }
  description = "IDs of attached volumes, keyed by the volumes map key."
}

output "firewall_id" {
  value       = one(digitalocean_firewall.this[*].id)
  description = "Cloud firewall ID, or null when no firewall is created."
}
