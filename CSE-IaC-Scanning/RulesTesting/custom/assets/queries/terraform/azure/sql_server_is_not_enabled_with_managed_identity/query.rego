package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
    azureSQLServer := input.document[i].resource.azurerm_mssql_server[name].identity
    count(azureSQLServer) == 0

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(azureSQLServer, name),
        "searchKey": "azurerm_mssql_server.identity",
        "issueType": "MissingAttribute",
        "keyExpectedValue": "The 'identity' block should be present in the azurerm_mssql_server resource",
        "keyActualValue": "Identity block is missing or undefined",
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "identity"], []),
        "remediation": "Add an 'identity' block to enable managed identity",
        "remediationType": "addition",
    }
}

CxPolicy[result] {
    azureSQLServer := input.document[i].resource.azurerm_mssql_server[name].identity[j]
    azureSQLServer.type != "UserAssigned"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(azureSQLServer, name),
        "searchKey": "azurerm_mssql_server.identity",
        "issueType": "Misconfiguration",
        "keyExpectedValue": "The 'identity' type should be UserAssigned",
        "keyActualValue": "The 'identity' type is not UserAssigned",
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "identity"], []),
        "remediation": "update identity type as User Assigned",
        "remediationType": "update",
    }
}