#this code is a correct code for which the query should not find any result
resource "azurerm_postgresql_flexible_server_configuration" "negative1" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative2" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "On"
}

resource "azurerm_postgresql_flexible_server_configuration" "negative3" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "ON"
}