# Ansible

This directory contains Ansible deployment scripts for RethinkDB servers. The GitHub runner token stays in the `GITHUB_ACCESS_TOKEN` environment variable. When a file is Vault-encrypted, the password goes in `.vault-pass`, which is not committed.

## Getting Started

1. Create a Python 3.12 virtualenv and install Python requirements, `pip install -r requirements.txt`.
2. Install Ansible requirements, `ansible-galaxy install --force -r requirements.yaml`.
3. Execute `ansible-playbook playbooks/<playbook>.yml -l <limit>`, where `<playbook>` is the service-specific playbook, and `<limit>` is a specific host or group from the [inventory.ini](inventory.ini) file.

The first connection to a host stores its SSH key. A rebuilt droplet fails until the old key is removed with `ssh-keygen -R <host>`.

_**macOS notes: On macOS, add `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` to your `zshrc`, as ansible have a process forking bug: <https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos-as-a-control-node>. Also, make sure your `tar` command is `GNU tar`. On macOS, install it by executing `brew install gnu-tar`._

## Initial playbook runs

`playbooks/initial-access.yml` refuses to run without `--limit`. Pass `--limit all` only when every host should be updated. For DigitalOcean Droplets, use `ansible_user=root` until the `ubuntu` user exists. SSH keys for `ubuntu` are replaced with the keys published by the GitHub users in [group_vars/all.yml](group_vars/all.yml).

## Package upgrades

Playbooks install `unattended-upgrades` for security updates. A full package upgrade runs only when requested:

`ansible-playbook playbooks/<playbook>.yml -l <limit> --tags package-upgrade`

## Private GitHub runners

`playbooks/private-github-runner.yml` reads `GITHUB_ACCESS_TOKEN` from the environment. Add each runner to the `github_runner` group in [inventory.ini](inventory.ini). The runner version is pinned in the role defaults.

## Update checker

The update checker runs as the `update-checker` user under systemd. Read its logs with `journalctl -u rethinkdb-update`.

## Working with Ansible Vault

Before inlining any encrypted passwords, carefully consider whether it's truly necessary. Ansible Vault allows you to encrypt strings or files directly within Ansible without needing additional installations.

Always use the same Ansible Vault password for all encryptions. To encrypt a complete file, use `ansible-vault encrypt file.ext`. To view the contents later, use `ansible-vault view file.ext`.

Place the password in `.vault-pass` in this directory. Alternatively, provide the password interactively with `--ask-vault-pass`.

To encrypt a string for use as a variable, use `ansible-vault encrypt_string --name 'var_name' <secret>`. The resulting output can be used like any other variable.

To verify proper encryption, run:
`ansible localhost -m debug -a var="var_name" -e "@file_with_encrypted_var.yml"`.
