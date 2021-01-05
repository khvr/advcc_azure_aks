# data "azurerm_resource_group" "rg" {
#   name = var.resourceGroupName
# }

module "res_group" {
  source            = "../../modules/resource_group/"
  resourceGroupName = var.resourceGroupName
  location          = var.location
}

resource "azurerm_virtual_network" "azure_aks_vnet" {
  name                = "azure_aks_vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = module.res_group.res_group_name
}

resource "azurerm_subnet" "azure_aks_subnet" {
  name                 = "azure-aks-subnet"
  resource_group_name  = module.res_group.res_group_name
  virtual_network_name = azurerm_virtual_network.azure_aks_vnet.name
  address_prefixes     = ["10.1.0.0/22"]
  service_endpoints    = ["Microsoft.Sql"]
  #   ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_kubernetes_cluster" "aks-getting-started" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = module.res_group.res_group_name
  dns_prefix          = "aks-getting-started"
  kubernetes_version  = var.kubernetes_version

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "Standard"
    network_policy    = "calico"
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  default_node_pool {
    name                = "default"
    node_count          = 3
    vm_size             = "Standard_D2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 6
    vnet_subnet_id      = azurerm_subnet.azure_aks_subnet.id
    availability_zones  = ["1", "2", "3"]
  }

  service_principal {
    client_id     = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
  }

}


