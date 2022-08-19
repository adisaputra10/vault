disable_cache = true
disable_mlock = true
ui = true
listener "tcp" {
   address          = "0.0.0.0:8200"
   tls_disable      = 1
}

api_addr         = "http://0.0.0.0:8200"
max_lease_ttl         = "10h"
default_lease_ttl    = "10h"
cluster_name         = "vault"
#raw_storage_endpoint     = true
disable_sealwrap     = true
disable_printable_check = true



storage "mysql" {
  ha_enabled = "true"
  address = "db-jenkins-vault-1.cc54qf5oqihr.ap-southeast-1.rds.amazonaws.com:3306"
  username = "admin_vault"
  password = "jASe0UFRh7dPxyGgfthm"
  database = "vault"

}
