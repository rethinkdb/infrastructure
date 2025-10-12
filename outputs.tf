output "download_server_ip" {
  value       = digitalocean_droplet.download_server.ipv4_address
  description = "IPv4 address of the download server."
}

output "update_checker_server_ip" {
  value       = digitalocean_droplet.update_checker_server.ipv4_address
  description = "IPv4 address of the update checker server."
}

output "private_github_runner_ips" {
  value       = digitalocean_droplet.private_github_runner.*.ipv4_address
  description = "IPv4 addresses of the private GitHub runneres."
}

