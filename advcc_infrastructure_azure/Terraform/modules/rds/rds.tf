# data "azurerm_resource_group" "rg" {
#   name = var.resourceGroupName
# }

module "res_group" {
  source            = "../../modules/resource_group/"
  resourceGroupName = var.resourceGroupName
  location          = var.location
}

resource "azurerm_virtual_network" "azure_mysql_vnet" {
  name                = "azure_mysql_vnet"
  address_space       = ["172.16.0.0/16"]
  location            = var.location
  resource_group_name = module.res_group.res_group_name
}

resource "azurerm_subnet" "azure_mysql_subnet" {
  name                 = "azure_mysql_subnet"
  resource_group_name  = module.res_group.res_group_name
  virtual_network_name = azurerm_virtual_network.azure_mysql_vnet.name
  address_prefixes     = ["172.16.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "mydelegation"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_mysql_virtual_network_rule" "azure_mysql_vnetrule_aks3" {
  count               = 3
  name                = "akssqlrule"
  resource_group_name = module.res_group.res_group_name
  server_name         = "private-instance-${count.index + 1}-${random_id.db_name_suffix.hex}"
  subnet_id           = var.azure_aks_subnet_id
  depends_on          = [var.azure_aks_subnet]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "azurerm_mysql_server" "csye7125server" {
  count               = 3
  name                = "private-instance-${count.index + 1}-${random_id.db_name_suffix.hex}"
  location            = var.location
  resource_group_name = module.res_group.res_group_name

  sku_name   = "GP_Gen5_2"
  storage_mb = "5120"
  # backup_retention_days         = var.backup_retention_days
  # geo_redundant_backup_enabled  = var.geo_redundant_backup

  administrator_login           = var.cloud_sql_user
  administrator_login_password  = var.cloud_sql_password
  version                       = "5.7"
  ssl_enforcement_enabled       = false
  public_network_access_enabled = true
}

resource "azurerm_mysql_database" "database" {
  count               = 3
  name                = var.cloud_sql_db_names[count.index]
  resource_group_name = module.res_group.res_group_name
  server_name         = "private-instance-${count.index + 1}-${random_id.db_name_suffix.hex}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on          = [azurerm_mysql_server.csye7125server]
}

resource "azurerm_dns_zone" "zone" {
  name                = var.hosted_zone
  resource_group_name = module.res_group.res_group_name
}
