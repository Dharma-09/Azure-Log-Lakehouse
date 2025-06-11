
provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "East US"
}

variable "resource_group_name" {
  type    = string
  default = "loglakehouse-rg"
}

variable "eventhub_namespace_name" {
  type    = string
  default = "loglakehouse-ehns"
}

variable "eventhub_name" {
  type    = string
  default = "logs"
}

variable "function_app_name" {
  type    = string
  default = "log-lake-func"
}

variable "function_plan_name" {
  type    = string
  default = "log-func-plan"
}

variable "storage_account_name_prefix" {
  type    = string
  default = "loglakehouse"
}

variable "function_storage_account_name_prefix" {
  type    = string
  default = "logfunctf"
}

variable "synapse_workspace_name" {
  type    = string
  default = "loglakehousews"
}

variable "synapse_sql_admin" {
  type    = string
  default = "sqladminuser"
}

variable "synapse_sql_password" {
  type    = string
  default = "synapse-sql-password"
}

variable "key_vault_name" {
  type    = string
  default = "loglakehousekv"
}

variable "log_analytics_workspace_name" {
  type    = string
  default = "loglakehouse-law"
}