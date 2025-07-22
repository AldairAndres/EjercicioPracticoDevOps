###########################################################
# main.tf – Orquestación de módulos
###########################################################

module "rg" {                                        # Módulo Resource Group
  source         = "./modules/rg"                    # Ruta al módulo
  project_prefix = var.project_prefix
  location       = var.location
  tags           = var.tags
}

module "network" {                                   # Módulo de red
  source         = "./modules/network"
  project_prefix = var.project_prefix
  location       = var.location
  resource_group = module.rg.name                    # RG creado arriba
  vnet_cidr      = var.vnet_cidr
  subnet_cidr    = var.subnet_cidr
  tags           = var.tags

  depends_on = [ module.rg ]                         # Orden explícito
}

module "acr" {                                       # Módulo ACR
  source         = "./modules/acr"
  project_prefix = var.project_prefix
  location       = var.location
  resource_group = module.rg.name
  tags           = var.tags

  depends_on = [ module.rg ]
}

module "aks" {                                       # Módulo AKS
  source              = "./modules/aks"
  project_prefix      = var.project_prefix
  location            = var.location
  resource_group      = module.rg.name
  subnet_id           = module.network.subnet_id
  node_count          = var.node_count
  node_size           = var.node_size
  tags                = var.tags
  acr_id              = module.acr.id                # Para role assignment
  kubelet_object_id   = null                          # Se resuelve dentro del módulo

  depends_on = [                                     # Red y RG deben existir
    module.network,
    module.acr
  ]
}
