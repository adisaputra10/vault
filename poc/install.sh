#!/usr/bin/env bash

# Install Vault
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update -y && apt install vault -y

# Update vault config
read -r -p "Enter node id: " node_id

host_ip=$(hostname -I | xargs)
echo "Host IP: $host_ip"

cp ./vault.hcl /etc/vault.d/vault.hcl
sed -i s"|{{HOST_IP}}|${host_ip}|"g /etc/vault.d/vault.hcl
sed -i s"|{{NODE_ID}}|${node_id}|"g /etc/vault.d/vault.hcl

# Start vault
systemctl start vault

# Helper for Vault cli
vault -autocomplete-install
export VAULT_ADDR="http://127.0.0.1:8200"

# Join cluster
read -r -p "Join another cluster? (y/N): " joining
if [[ $joining == [yY] || $joining == [yY][eE][sS] ]]; then
    read -r -p "Enter the cluster leader ip: " leader_ip
    vault operator raft join "http://${leader_ip}:8200"
fi

echo "Installation finished"
