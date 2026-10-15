resource "digitalocean_droplet" "this" {
  name          = var.name
  image         = var.image
  region        = var.region
  size          = var.size
  ssh_keys      = var.ssh_keys
  droplet_agent = var.droplet_agent
  monitoring    = var.monitoring
  backups       = var.backups
  tags          = distinct(concat(var.tags, ["terraform-managed"]))

  dynamic "backup_policy" {
    for_each = var.backups && var.backup_policy != null ? [var.backup_policy] : []

    content {
      plan    = backup_policy.value.plan
      weekday = backup_policy.value.weekday
      hour    = backup_policy.value.hour
    }
  }
}

resource "digitalocean_volume" "this" {
  for_each = var.volumes

  name                    = coalesce(each.value.name, each.key)
  description             = each.value.description
  region                  = var.region
  size                    = each.value.size
  initial_filesystem_type = each.value.initial_filesystem_type
  tags                    = distinct(concat(coalesce(each.value.tags, var.tags), ["terraform-managed"]))
}

resource "digitalocean_volume_attachment" "this" {
  for_each = var.volumes

  droplet_id = digitalocean_droplet.this.id
  volume_id  = digitalocean_volume.this[each.key].id
}

resource "digitalocean_firewall" "this" {
  count = var.firewall == null ? 0 : 1

  name = coalesce(
    var.firewall == null ? null : var.firewall.name,
    "${var.name}-firewall",
  )

  droplet_ids = [digitalocean_droplet.this.id]

  dynamic "inbound_rule" {
    for_each = var.firewall == null ? [] : var.firewall.inbound_rules

    content {
      protocol                  = inbound_rule.value.protocol
      port_range                = inbound_rule.value.port_range
      source_addresses          = inbound_rule.value.source_addresses
      source_droplet_ids        = inbound_rule.value.source_droplet_ids
      source_tags               = inbound_rule.value.source_tags
      source_load_balancer_uids = inbound_rule.value.source_load_balancer_uids
    }
  }

  dynamic "outbound_rule" {
    for_each = var.firewall == null ? [] : var.firewall.outbound_rules

    content {
      protocol                       = outbound_rule.value.protocol
      port_range                     = outbound_rule.value.port_range
      destination_addresses          = outbound_rule.value.destination_addresses
      destination_droplet_ids        = outbound_rule.value.destination_droplet_ids
      destination_tags               = outbound_rule.value.destination_tags
      destination_load_balancer_uids = outbound_rule.value.destination_load_balancer_uids
    }
  }
}
