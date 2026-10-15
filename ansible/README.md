# Ansible

This directory contains ansible deployment scripts for deploying a variety of RethinkDB servers. It is intentionally private and contains (encrypted) production secrets.

## Getting Started

1. Create a Python 3.12 virtualenv and install Python requirements, `pip install -r requirements.txt`.
2. Install Ansible requirements, `ansible-galaxy install --force -r requirements.yml`.
3. Place the Ansible Vault password into a file named `.vault-pass`.
4. Execute `ansible-playbook playbooks/<playbook>.yml -l <limit>`, where `<playbook>` is the service-specific playbook, and `<limit>` is a specific host or group from the [inventory.ini](inventory.ini) file.

_**macOS notes: On macOS, add `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` to your `zshrc`, as ansible have a process forking bug: <https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos-as-a-control-node>. Also, make sure your `tar` command is `GNU tar`. On macOS, install it by executing `brew install gnu-tar`._

## Initial playbook runs

For DigitalOcean Droplets, use `ansible_user=root` in the inventory or CLI until the common playbook is not applied. Once it is done, remove the parameter.

## Working with Ansible Vault

Before inlining any encrypted passwords, carefully consider whether it's truly necessary. Ansible Vault allows you to encrypt strings or files directly within Ansible without needing additional installations.

Always use the same Ansible Vault password for all encryptions. To encrypt a complete file, use `ansible-vault encrypt file.ext`. To view the contents later, use `ansible-vault view file.ext`.

Encrypted files function just like regular ones. Ansible automatically searches for the `.vault-pass` file in the root of the ansible-secrets repository. Alternatively, you can provide the password interactively with `--ask-vault-pass`.

To encrypt a string for use as a variable, use `ansible-vault encrypt_string --name 'var_name' <secret>`. The resulting output can be used like any other variable.

To verify proper encryption, run:
`ansible localhost -m debug -a var="var_name" -e "@file_with_encrypted_var.yml"`.
