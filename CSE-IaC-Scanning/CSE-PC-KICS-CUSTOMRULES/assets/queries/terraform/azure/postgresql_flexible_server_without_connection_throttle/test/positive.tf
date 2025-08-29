resource "azurerm_postgresql_flexible_server_configuration" "positive1" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "off"
}

resource "azurerm_postgresql_flexible_server_configuration" "positive2" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "Off"
}

resource "azurerm_postgresql_flexible_server_configuration" "positive3" {
    name                = "connection_throttle"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "OFF"
}