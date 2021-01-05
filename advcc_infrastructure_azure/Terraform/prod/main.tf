provider "azurerm" {
  version = "~>2.0"

  subscription_id = var.subscription_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
  tenant_id       = var.tenant_id

  features {}
}

module "res_group" {
  source            = "../modules/resource_group/"
  resourceGroupName = var.resourceGroupName
  location          = var.location
}

module "cluster" {
  source               = "../modules/cluster/"
  serviceprinciple_id  = var.serviceprinciple_id
  serviceprinciple_key = var.serviceprinciple_key
  ssh_key              = var.ssh_key
  location             = var.location
  kubernetes_version   = var.kubernetes_version
  resourceGroupName    = var.resourceGroupName
  cluster_name         = var.cluster_name
}

module "rds" {
  source              = "../modules/rds/"
  azure_aks_subnet    = module.cluster.azure_aks_subnet
  azure_aks_subnet_id = module.cluster.azure_aks_subnet_id
  cloud_sql_password  = var.cloud_sql_password
  cloud_sql_user      = var.cloud_sql_user
  cloud_sql_db_names  = var.cloud_sql_db_names
  resourceGroupName   = var.resourceGroupName
  hosted_zone         = var.hosted_zone
  location            = var.location
}
