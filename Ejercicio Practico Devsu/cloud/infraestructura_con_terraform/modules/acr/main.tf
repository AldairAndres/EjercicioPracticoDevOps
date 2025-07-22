variable "project_prefix" { type = string }
variable "location"       { type = string }
variable "resource_group" { type = string }
variable "tags"           { type = map(string) }

resource "random_string" "suffix" {            # Sufijo para nombre único
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.project_prefix}acr${random_string.suffix.result}" # ej: pruebajavaacr4a2b1c
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = var.tags
}

output "id" {
  value = azurerm_container_registry.acr.id
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}
