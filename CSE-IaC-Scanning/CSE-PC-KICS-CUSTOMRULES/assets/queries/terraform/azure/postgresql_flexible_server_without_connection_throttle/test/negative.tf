resource "azurerm_postgresql_flexible_server_configuration" "negative1" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative2" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "On"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative3" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "ON"
}