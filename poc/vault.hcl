ui = true

# When using raft, mlock should be disabled
disable_mlock = true
storage "raft" {
  path = "/opt/vault/data"
  node_id = "{{NODE_ID}}"
}

# HTTP listener
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://{{HOST_IP}}:8200"
cluster_addr = "https://{{HOST_IP}}:8201"
cluster_name = "vault"

# Enterprise license_path
# This will be required for enterprise as of v1.8
#license_path = "/etc/vault.d/vault.hclic"
