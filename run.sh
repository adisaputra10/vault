
#!/bin/bash
apt update -y
apt install unzip -y
VAULT_URL="https://releases.hashicorp.com/vault"
VAULT_VERSION="1.5.0"

wget  "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"


unzip vault_${VAULT_VERSION}_linux_amd64.zip

sudo chown root:root vault
sudo mv vault /usr/local/bin/
vault --version

vault -autocomplete-install
complete -C /usr/local/bin/vault vault
sudo useradd --system --home /etc/vault.d --shell /bin/false vault

mkdir -p /etc/vault.d
cp vault.hcl /etc/vault.d/vault.hcl
sudo touch /etc/systemd/system/vault.service
cp vault.service /etc/systemd/system/vault.service
systemctl daemon-reload
systemctl enable vault
systemctl restart vault
