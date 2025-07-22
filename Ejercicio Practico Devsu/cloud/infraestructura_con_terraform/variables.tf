variable "project_prefix" {
  description = "Prefijo corto para nombrar recursos."
  type        = string
}

variable "location" {
  description = "Región Azure (eastus, westeurope, etc.)."
  type        = string
}

variable "node_count" {
  description = "Cantidad de nodos en el pool principal del AKS."
  type        = number
}

variable "node_size" {
  description = "SKU de VM para los nodos del AKS."
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR de la VNet."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR de la subred donde corre AKS."
  type        = string
}

variable "tags" {
  description = "Mapa de etiquetas comunes a todos los recursos."
  type        = map(string)
}
