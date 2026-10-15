# Infrastructure

This repository manages RethinkDB servers on DigitalOcean. [OpenTofu](https://opentofu.org) creates the droplets. Ansible configures them. DNS stays with the DNS provider; this repository has no API access to it.

| Service | Host | Where it is defined |
| --- | --- | --- |
| Package repository (Nexus OSS) | `download.rethinkdb.com` | `terraform/boundaries/core-infra`, `ansible/playbooks/nexus-oss-repository.yml` |
| Update checker | `update.rethinkdb.com` | `terraform/boundaries/core-infra`, `ansible/playbooks/update-checker.yml` |
| Private GitHub Actions runners | `github_runner` inventory group | `terraform/boundaries/github`, `ansible/playbooks/private-github-runner.yml` |

`ansible/playbooks/initial-access.yml` creates the `ubuntu` login user and installs SSH keys before the service playbooks run.

Tokens and the Ansible Vault password stay on the operator machine. `*.tfvars` and `ansible/.vault-pass` are not committed.

## Ansible

Host configuration lives in [ansible/](ansible/README.md). Production secrets in that tree are Vault-encrypted. Install dependencies, place the Vault password, and run a playbook from the instructions there.

## Terraform

Droplet definitions live in [terraform/](terraform/README.md) and are applied with OpenTofu. `boundaries/core-infra` holds the download and update servers. `boundaries/github` holds the private runners. Each boundary has its own state in DigitalOcean Spaces.

## Checks

Install [pre-commit](https://pre-commit.com) and enable the hooks:

```bash
pre-commit install
```

The hooks format Terraform, YAML, and Markdown, and they check YAML, GitHub Actions workflows, Ansible, and the OpenTofu configuration. OpenTofu checks run `tofu fmt -recursive`, then `tofu init -backend=false` and `tofu validate` in each boundary. Pull requests and pushes to `main` run the same hooks.
