resource "azurerm_mysql_flexible_server_configuration" "negative1" {
  name                = "audit_log_enabled"
  server_name         = azurerm_mysql_flexible_server.default.name
  resource_group_name = azurerm_resource_group.rg.name
  value               = "on"
}