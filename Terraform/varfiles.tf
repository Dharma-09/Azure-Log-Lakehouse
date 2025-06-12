
provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "East US"
}

variable "resource_group_name" {
  type    = string
  default = "datalake-rg"
}

variable "eventhub_namespace_name" {
  type    = string
  default = "datalake-ehns"
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
  default = "datalake"
}

variable "function_storage_account_name_prefix" {
  type    = string
  default = "logfunctf"
}

variable "synapse_workspace_name" {
  type    = string
  default = "datalakews"
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
  default = "datalakekv"
}

variable "log_analytics_workspace_name" {
  type    = string
  default = "datalake-law"
}