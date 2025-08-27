#this is a problematic code where the query should report a result(s)
resource "azurerm_postgresql_flexible_server_configuration" "positive1" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "off"
}

resource "azurerm_postgresql_flexible_server_configuration" "positive2" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "Off"
}

resource "azurerm_postgresql_flexible_server_configuration" "positive3" {
    name                = "log_disconnections"
    server_id           = azurerm_postgresql_flexible_server.example.id
    value               = "OFF"
}