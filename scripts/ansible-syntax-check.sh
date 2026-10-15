#!/usr/bin/env bash
# Syntax-check every playbook in this Ansible project.
#
# Usage:
#   scripts/ansible-syntax-check.sh
#
# Requires ansible-galaxy and ansible-playbook on PATH.
# Reads ansible/.vault-pass when it exists. When it does not, the check
# still loads ansible.cfg and does not invent a vault password.
# Galaxy roles and collections are cached under
# ${XDG_CACHE_HOME:-$HOME/.cache}/ansible-syntax and reinstalled only when
# ansible/requirements.yaml changes.

set -euo pipefail

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$root/ansible"

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ansible-syntax"
stamp="$cache_dir/requirements.stamp"
export ANSIBLE_ROLES_PATH="$cache_dir/roles"
export ANSIBLE_COLLECTIONS_PATH="$cache_dir/collections"
if ! cmp -s requirements.yaml "$stamp"; then
  rm -rf "$cache_dir"
  mkdir -p "$cache_dir/roles" "$cache_dir/collections"
  ansible-galaxy install -r requirements.yaml
  cp requirements.yaml "$stamp"
fi
if [ ! -f .vault-pass ]; then
  config_dir=$(mktemp -d)
  trap 'rm -rf "$config_dir"' EXIT
  config_file="$config_dir/ansible.cfg"
  grep -v '^vault_password_file' ansible.cfg | sed "s|^inventory = inventory.ini|inventory = ${root}/inventory.ini|" > "$config_file"
  export ANSIBLE_CONFIG="$config_file"
fi
for playbook in playbooks/*.yml; do
  ansible-playbook "$playbook" --syntax-check
done
