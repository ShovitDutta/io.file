package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    sqlServer := input.document[i].resource.azurerm_mssql_server[name].azuread_administrator[j]
    not common_lib.valid_key(sqlServer,"azuread_authentication_only")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(sqlServer, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].azuread_administrator.azuread_authentication_only", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Azure AD authentication should be enforced (azuread_authentication_only = true)",
        "keyActualValue": "azuread_authentication_only is missing or false",
        "remediation": "Ensure that 'azuread_authentication_only' is set to true to enforce Azure AD authentication only",
        "remediationType": "modification",
    }
}

CxPolicy[result] {
    sqlServer := input.document[i].resource.azurerm_mssql_server[name]
    common_lib.valid_key(sqlServer, "administrator_login")
    sqlServerAdmin := input.document[i].resource.azurerm_mssql_server[name].azuread_administrator[j]
    sqlServerAdmin.azuread_authentication_only != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_mssql_server[name], name),
        "searchKey": sprintf("azurerm_mssql_server[%s].administrator_login", [name]),
        "issueType": "Misconfiguration",
        "keyExpectedValue": "Azure AD authentication should be the only method enabled",
        "keyActualValue": sprintf("SQL Server has an administrator login: %v", [sqlServer.administrator_login]),
        "remediation": "Remove the administrator_login to enforce Azure AD authentication only",
        "remediationType": "modification",
    }
}