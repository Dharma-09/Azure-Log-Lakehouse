output "function_app_default_hostname" {
  value = azurerm_function_app.func.default_hostname
  description = "The default hostname of the function app"
}

output "function_app_name" {
  value = azurerm_function_app.func.name
}
