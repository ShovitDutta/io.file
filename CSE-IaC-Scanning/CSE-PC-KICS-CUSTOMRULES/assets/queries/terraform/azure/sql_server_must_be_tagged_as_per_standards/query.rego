package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Check if the 'itpmid' tag is missing
CxPolicy[result] {
    resource := input.document[i].resource.azurerm_mssql_server[name]
    not common_lib.valid_key(resource.tags,"itpmid")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].tags.itpmid", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_mssql_server[%s].tags.itpmid should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_mssql_server[%s].tags.itpmid is undefined or null", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "tags"], []),
        "remediation": "Update the 'itpmid' tag on the SQL Server",
        "remediationType": "addition",
    }
}

# Check if the 'costcenter' tag is missing
CxPolicy[result] {
    resource := input.document[i].resource.azurerm_mssql_server[name]
    not common_lib.valid_key(resource.tags,"costcenter")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].tags.costcenter", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_mssql_server[%s].tags.costcenter should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_mssql_server[%s].tags.costcenter is undefined or null", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "tags"], []),
        "remediation": "Update the 'costcenter' tag on the SQL Server",
        "remediationType": "addition",
    }
}

# Check if the 'dataclassification' tag is missing
CxPolicy[result] {
    resource := input.document[i].resource.azurerm_mssql_server[name]
    not common_lib.valid_key(resource.tags,"dataclassification")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].tags.dataclassification", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_mssql_server[%s].tags.dataclassification should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_mssql_server[%s].tags.dataclassification is undefined or null", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "tags"], []),
        "remediation": "Update the 'dataclassification' tag on the SQL Server",
        "remediationType": "addition",
    }
}

# Check if the 'environmenttype' tag is missing
CxPolicy[result] {
    resource := input.document[i].resource.azurerm_mssql_server[name]
    not common_lib.valid_key(resource.tags,"environmenttype")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].tags.environmenttype", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_mssql_server[%s].tags.environmenttype should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_mssql_server[%s].tags.environmenttype is undefined or null", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "tags"], []),
        "remediation": "Update the 'environmenttype' tag on the SQL Server",
        "remediationType": "addition",
    }
}

# Check if the 'sharedemailaddress' tag is missing
CxPolicy[result] {
    resource := input.document[i].resource.azurerm_mssql_server[name]
    not common_lib.valid_key(resource.tags,"sharedemailaddress")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_mssql_server",
        "resourceName": tf_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_mssql_server[%s].tags.sharedemailaddress", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_mssql_server[%s].tags.sharedemailaddress should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_mssql_server[%s].tags.sharedemailaddress is undefined or null", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "tags"], []),
        "remediation": "Update the 'sharedemailaddress' tag on the SQL Server",
        "remediationType": "addition",
    }
}