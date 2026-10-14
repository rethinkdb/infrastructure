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
2. Create a `secret.auto.tfvars` file in each boundary directory to store
   your `digitalocean_token`.
3. Execute the commands below from the boundary you want to change.

Production servers live in `terraform/boundaries/core-infra`. GitHub runners live in
`terraform/boundaries/github`. Each directory has its own state.

### Usage

Initialize the terraform state:

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

## Checks

Install [pre-commit](https://pre-commit.com) and enable the hooks:

```bash
$ pre-commit install
```

The hooks format Terraform, YAML, and Markdown, and they check YAML,
GitHub Actions workflows, and the OpenTofu configuration. OpenTofu checks run
`tofu fmt -recursive`, then `tofu init -backend=false` and `tofu validate` in
each boundary. Pull requests and merges to `main` run pre-commit.
