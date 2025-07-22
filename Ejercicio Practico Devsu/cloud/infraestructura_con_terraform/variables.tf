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

# Identificación de la suscripción (solo si no usas az login)
variable "subscription_id" {
  type        = string
  description = "ID de la suscripción de Azure donde se aprovisionará la infraestructura."
}

# Tenant (directorio AAD)
variable "tenant_id" {
  type        = string
  description = "ID del tenant (Azure AD) que contiene la suscripción."
}

# Credenciales del Service Principal (si eliges autenticación con SP)
variable "client_id" {
  type        = string
  description = "App ID (client_id) del Service Principal usado por Terraform."
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Client secret del Service Principal usado por Terraform."
  sensitive   = true
}
