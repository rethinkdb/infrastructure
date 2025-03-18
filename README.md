# Infrastructure

This repository contains the Terraform resource definitions for the servers
operated for RethinkDB. This includes the download and update checker servers.

The DNS records are not managed with Terraform as we have no API access for the
DNS provider.

## Getting started

### Prerequisites

- [Open Tofu](https://opentofu.org) cli
- [DigitalOcean](https://digitalocean.com) access

### Setup

1. Create a new AWS profile in `~/.aws/credentials`, called `rethinkdb` with
   the DigitalOcean spaces access key ID and Secret access key.
2. Create a new `secret.auto.tfvars` file to store your `digitalocean_token`.
3. Execute the commands below.

### Usage

Initialize the terraform state and select your workspace:

```bash
$ tofu init
```

See what plan would be executed:

```bash
$ tofu plan
```

Check the final plan and apply the changes:

```bash
$ tofu apply
```
