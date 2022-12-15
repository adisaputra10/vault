#!/bin/bash

service vault stop

VAULT_URL="https://releases.hashicorp.com/vault"
VAULT_VERSION="1.12.2"

wget "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"

unzip "vault_${VAULT_VERSION}_linux_amd64.zip"

chown root:root vault
mv vault /usr/local/bin/

# Disable mlock = false
sed -i s"/disable_mlock = true/disable_mlock = false/"g /etc/vault.d/vault.hcl
setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Verify vault version
INSTALLED_VERSION=$(vault --version)
if [[ $INSTALLED_VERSION != "Vault v${VAULT_VERSION}" ]]; then
    echo "Installed version is invalid ${INSTALLED_VERSION}"
    exit 1
fi

service vault start

echo "You can unseal the vault now"
