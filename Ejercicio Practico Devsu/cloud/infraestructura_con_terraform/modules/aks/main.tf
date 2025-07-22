variable "project_prefix"    { type = string }
variable "location"          { type = string }
variable "resource_group"    { type = string }
variable "subnet_id"         { type = string }
variable "node_count"        { type = number }
variable "node_size"         { type = string }
variable "tags"              { type = map(string) }
variable "acr_id"            { type = string }

# Información del tenant/subscripción
data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.project_prefix}-dns"

  identity {
    type = "SystemAssigned"                     # Identidad administrada
  }

  default_node_pool {
    name                         = "np1"
    node_count                   = var.node_count
    vm_size                      = var.node_size
    vnet_subnet_id               = var.subnet_id
    only_critical_addons_enabled = false
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  oidc_issuer_enabled = true                   # Recomendado para autenticación futura

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count          # Evita recrear al escalar manualmente
    ]
  }

  depends_on = [
    var.subnet_id                               # expresado como string; real dependencia resuelta por valor
  ]
}

# Asigna rol AcrPull a la identidad del kubelet
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
