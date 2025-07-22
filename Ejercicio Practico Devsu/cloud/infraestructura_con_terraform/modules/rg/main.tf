variable "project_prefix" { type = string }
variable "location"       { type = string }
variable "tags"           { type = map(string) }

resource "azurerm_resource_group" "this" {     # Grupo de recursos contenedor
  name     = "${var.project_prefix}-rg"        # Ej: pruebajava-rg
  location = var.location                      # Región indicada

  tags = var.tags                              # Etiquetas comunes
}

output "name" {
  value = azurerm_resource_group.this.name
}
