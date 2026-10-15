locals {
  default_ssh_keys = [
    "04:78:a1:f2:ff:05:dc:73:4d:eb:7f:83:e3:b9:26:e2" # RethinkDB Shared SSH Key
  ]
}

module "private_github_runner" {
  source = "../../modules/droplet"

  count = var.private_github_runner_count

  name     = "rethinkdb-private-github-runner-${count.index}"
  region   = var.digitalocean_region
  size     = "s-4vcpu-8gb"
  ssh_keys = local.default_ssh_keys
  tags     = ["build-and-test"]
}
