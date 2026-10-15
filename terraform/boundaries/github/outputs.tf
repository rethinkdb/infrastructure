output "private_github_runner_ips" {
  value       = module.private_github_runner[*].ipv4_address
  description = "IPv4 addresses of the private GitHub runneres."
}
