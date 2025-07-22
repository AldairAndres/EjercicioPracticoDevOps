output "kube_config" {                               # kubeconfig crudo
  description = "Contenido kubeconfig del AKS (raw)."
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "acr_login_server" {                          # URL del ACR
  description = "Servidor de login del ACR."
  value       = module.acr.login_server
}

output "resource_group_name" {
  description = "Nombre del RG."
  value       = module.rg.name
}
