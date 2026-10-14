locals {
  default_ssh_keys = [
    "04:78:a1:f2:ff:05:dc:73:4d:eb:7f:83:e3:b9:26:e2" # RethinkDB Shared SSH Key
  ]
}

module "download_server" {
  source = "./modules/droplet"

  name     = "rethinkdb-download-server"
  region   = var.digitalocean_region
  size     = "s-2vcpu-4gb"
  ssh_keys = local.default_ssh_keys
  backups  = true
  tags     = ["production"]

  backup_policy = {
    plan    = "weekly"
    weekday = "SUN"
    hour    = 12
  }

  volumes = {
    nexus = {
      description = "Extra volume for the download server's blob store"
      size        = 100
      tags        = ["production"]
    }
  }
}

module "update_checker_server" {
  source = "./modules/droplet"

  name     = "rethinkdb-update-server"
  region   = var.digitalocean_region
  size     = "s-1vcpu-1gb"
  ssh_keys = local.default_ssh_keys
  tags     = ["production"]
}

module "private_github_runner" {
  source = "./modules/droplet"

  count = var.private_github_runner_count

  name     = "rethinkdb-private-github-runner-${count.index}"
  region   = var.digitalocean_region
  size     = "s-4vcpu-8gb"
  ssh_keys = local.default_ssh_keys
  tags     = ["build-and-test"]
}
