project_prefix = "pruebajava"
location       = "eastus"

node_count = 2
node_size  = "standard_b2s"

vnet_cidr   = "10.10.0.0/16"
subnet_cidr = "10.10.1.0/24"

subscription_id = "76d40293-1f93-4a23-9843-03ffa55c5b0a"
tenant_id       = "cbe7ad02-9427-432b-b882-0723acbeef53"
client_id       = "29a0088b-6930-4e1b-a534-41b5a588802f"
client_secret   = "J.A8Q~kUvMpjDk-PIZXJE5ncygEydZ_jXdawTdeG"

tags = {
  env   = "dev"
  owner = "devops"
}
