resource "azurerm_postgresql_flexible_server_configuration" "negative1" {
    name                = "log_connections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative2" {
    name                = "log_connections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "On"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative3" {
    name                = "log_connections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "ON"
}