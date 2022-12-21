#!/bin/bash

service vault stop

VAULT_URL="https://releases.hashicorp.com/vault"
VAULT_VERSION="1.12.2"

wget "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"
unzip "vault_${VAULT_VERSION}_linux_amd64.zip"
rm "vault_${VAULT_VERSION}_linux_amd64.zip"

chown root:root vault

mv /usr/local/bin/vault /usr/local/bin/vault.old
mv vault /usr/local/bin/

# Verify vault version
INSTALLED_VERSION=$(vault --version)
if [[ $INSTALLED_VERSION =~ "^Vault v${VAULT_VERSION}" ]]; then
    echo "Installed version is invalid ${INSTALLED_VERSION}"

    echo "Reverting..."
    mv /usr/local/bin/vault.old /usr/local/bin/vault
    service vault start

    exit 1
fi

# Disable mlock = false
sed -i s"/disable_mlock = true/disable_mlock = false/"g /etc/vault.d/vault.hcl
setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Change api_addr
host_ip=$(ip route get 1 | awk '{print $NF;exit}')
echo "new api_addr = http://${host_ip}:8200"
sed -i s"|http://0.0.0.0:8200|http://${host_ip}:8200|"g /etc/vault.d/vault.hcl

service vault start

echo "You can unseal the vault now"
