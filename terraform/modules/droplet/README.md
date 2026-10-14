## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [digitalocean_droplet.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_volume.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume) | resource |
| [digitalocean_volume_attachment.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_backup_policy"></a> [backup\_policy](#input\_backup\_policy) | Backup schedule. Used only when backups are enabled. | <pre>object({<br/>    plan    = string<br/>    weekday = optional(string)<br/>    hour    = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_backups"></a> [backups](#input\_backups) | Enable droplet backups. | `bool` | `false` | no |
| <a name="input_droplet_agent"></a> [droplet\_agent](#input\_droplet\_agent) | Install the DigitalOcean agent used for metrics and recovery. | `bool` | `true` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | Cloud firewall attached to this droplet. Null skips firewall creation. Name defaults to the droplet name plus -firewall. | <pre>object({<br/>    name = optional(string)<br/>    inbound_rules = optional(list(object({<br/>      protocol                  = string<br/>      port_range                = optional(string)<br/>      source_addresses          = optional(list(string))<br/>      source_droplet_ids        = optional(list(string))<br/>      source_tags               = optional(list(string))<br/>      source_load_balancer_uids = optional(list(string))<br/>    })), [])<br/>    outbound_rules = optional(list(object({<br/>      protocol                       = string<br/>      port_range                     = optional(string)<br/>      destination_addresses          = optional(list(string))<br/>      destination_droplet_ids        = optional(list(string))<br/>      destination_tags               = optional(list(string))<br/>      destination_load_balancer_uids = optional(list(string))<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | Droplet image slug. | `string` | `"ubuntu-24-04-x64"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Enable DigitalOcean monitoring. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Droplet name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region for the droplet. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Droplet size slug. | `string` | n/a | yes |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH key fingerprints or IDs to install on the droplet. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra droplet tags. terraform-managed is always added. | `list(string)` | `[]` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Block storage volumes to create and attach. The map key is the volume name when name is omitted. Tags default to the droplet tags. | <pre>map(object({<br/>    size                    = number<br/>    name                    = optional(string)<br/>    description             = optional(string)<br/>    initial_filesystem_type = optional(string, "ext4")<br/>    tags                    = optional(list(string))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | Cloud firewall ID, or null when no firewall is created. |
| <a name="output_id"></a> [id](#output\_id) | Droplet ID. |
| <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address) | Public IPv4 address. |
| <a name="output_ipv4_address_private"></a> [ipv4\_address\_private](#output\_ipv4\_address\_private) | Private IPv4 address. |
| <a name="output_name"></a> [name](#output\_name) | Droplet name. |
| <a name="output_urn"></a> [urn](#output\_urn) | Droplet uniform resource name. |
| <a name="output_volume_ids"></a> [volume\_ids](#output\_volume\_ids) | IDs of attached volumes, keyed by the volumes map key. |
