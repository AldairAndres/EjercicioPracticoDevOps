project_prefix = "pruebajava"
location       = "eastus"

node_count = 2
node_size  = "Standard_DS2_v2"

vnet_cidr   = "10.10.0.0/16"
subnet_cidr = "10.10.1.0/24"

tags = {
  env   = "dev"
  owner = "devops"
}
