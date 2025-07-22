variable "project_prefix" { type = string }
variable "location"       { type = string }
variable "resource_group" { type = string }
variable "vnet_cidr"      { type = string }
variable "subnet_cidr"    { type = string }
variable "tags"           { type = map(string) }

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_prefix}-vnet"  # Ej: pruebajava-vnet
  address_space       = [var.vnet_cidr]               # CIDR recibido
  location            = var.location
  resource_group_name = var.resource_group

  tags = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"                        # Nombre claro
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]                   # Sub-CIDR

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

output "subnet_id" {
  value = azurerm_subnet.aks.id
}
