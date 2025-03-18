locals {
  default_droplet_image = "ubuntu-24-04-x64"

  default_ssh_keys = [
    "04:78:a1:f2:ff:05:dc:73:4d:eb:7f:83:e3:b9:26:e2" # RethinkDB Shared SSH Key
  ]
}

resource "digitalocean_droplet" "download_server" {
  name          = "rethinkdb-download-server"
  image         = local.default_droplet_image
  region        = var.digitalocean_region
  size          = "s-2vcpu-4gb"
  ssh_keys      = local.default_ssh_keys
  droplet_agent = true
  monitoring    = true
  backups       = true
  tags = [
    "production",
    "terraform-managed"
  ]

  backup_policy {
    plan    = "weekly"
    weekday = "SUN"
    hour    = 12
  }
}

resource "digitalocean_volume" "download_server_blob_store" {
  name                    = "nexus"
  description             = "Extra volume for the download server's blob store"
  region                  = var.digitalocean_region
  initial_filesystem_type = "ext4"
  size                    = 100
  tags = [
    "production",
    "terraform-managed"
  ]
}

resource "digitalocean_volume_attachment" "download_server_blob_store" {
  droplet_id = digitalocean_droplet.download_server.id
  volume_id  = digitalocean_volume.download_server_blob_store.id
}

resource "digitalocean_droplet" "update_checker_server" {
  name          = "rethinkdb-update-server"
  image         = local.default_droplet_image
  region        = var.digitalocean_region
  ssh_keys      = local.default_ssh_keys
  size          = "s-1vcpu-1gb"
  droplet_agent = true
  monitoring    = true
  backups       = false
  tags = [
    "production",
    "terraform-managed"
  ]
}
