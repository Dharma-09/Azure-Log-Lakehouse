provider "azurerm" {
  features {}
}

#-----------------------------
# Resource Group
#-----------------------------
resource "azurerm_resource_group" "rg" {
  name     = "loglakehouse-rg"
  location = "East US"
}

#-----------------------------
# Storage Account with Data Lake Gen2
#-----------------------------
resource "azurerm_storage_account" "lake" {
  name                     = "loglakehouse${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

#-----------------------------
# Event Hub Namespace & Hub
#-----------------------------
resource "azurerm_eventhub_namespace" "eh_ns" {
  name                = "loglakehouse-ehns"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  capacity            = 1
  auto_inflate_enabled = false
}

resource "azurerm_eventhub" "eh" {
  name                = "logs"
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}

#-----------------------------
# Azure Function App
#-----------------------------
resource "azurerm_storage_account" "func_storage" {
  name                     = "logfunctf${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_plan" {
  name                = "log-func-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function" {
  name                       = "log-lake-func"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.func_storage.name
  storage_account_access_key = azurerm_storage_account.func_storage.primary_access_key
  version                    = "~4"
  os_type                    = "linux"
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    EVENT_HUB_NAME           = azurerm_eventhub.eh.name
    STORAGE_ACCOUNT_NAME     = azurerm_storage_account.lake.name
  }
  site_config {
    linux_fx_version = "Python|3.10"
  }
}

#-----------------------------
# Azure Synapse Analytics (Serverless SQL Pool)
#-----------------------------
resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "loglakehousews"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = azurerm_resource_group.rg.location
  storage_data_lake_gen2_filesystem_id = "${azurerm_storage_account.lake.id}/filesystem/default"
  sql_administrator_login              = synapse-sql-admin
  sql_administrator_login_password     = synapse-sql-synapse_sql_password
}

#-----------------------------
# Azure Key Vault
#-----------------------------
resource "azurerm_key_vault" "kv" {
  name                        = "loglakehousekv"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  #soft_delete_enabled         = true
}

data "azurerm_client_config" "current" {}

#-----------------------------
# Azure Monitor (Log Analytics)
#-----------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "loglakehouse-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
