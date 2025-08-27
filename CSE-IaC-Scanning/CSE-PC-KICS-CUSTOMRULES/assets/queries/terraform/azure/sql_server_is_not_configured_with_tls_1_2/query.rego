package Cx
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   azresource := input.document[i].resource.azurerm_mssql_server[name]
   not common_lib.valid_key(azresource, "minimum_tls_version")
   result := {
      "documentId": input.document[i].id,
      "resourceType": "azurerm_mssql_server",
      "resourceName": tf_lib.get_resource_name(azresource, name),
      "searchKey": sprintf("azurerm_mssql_server[%s].minimum_tls_version", [name]),
      "issueType": "MissingAttribute",
      "keyExpectedValue": sprintf("azurerm_mssql_server[%s].minimum_tls_version should be defined and set to 1.2 or higher", [name]),
      "keyActualValue": sprintf("azurerm_mssql_server[%s].minimum_tls_version is undefined", [name]),
      "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name], []),
      "remediation": "Add the minimum_tls_version and set it to 1.2 or higher",
      "remediationType": "addition",
   }
}

CxPolicy[result] {
   azresource := input.document[i].resource.azurerm_mssql_server[name]
   to_number(azresource.minimum_tls_version) < 1.2

   result := {
      "documentId": input.document[i].id,
      "resourceType": "azurerm_mssql_server",
      "resourceName": tf_lib.get_resource_name(azresource, name),
      "searchKey": sprintf("azurerm_mssql_server[%s].minimum_tls_version", [name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": sprintf("azurerm_mssql_server[%s].minimum_tls_version should be set to 1.2 or higher", [name]),
      "keyActualValue": sprintf("azurerm_mssql_server[%s].minimum_tls_version is not set to 1.2 or higher", [name]),
      "searchLine": common_lib.build_search_line(["resource", "azurerm_mssql_server", name, "minimum_tls_version"], []),
      "remediation": "Set minimum_tls_version to 1.2 or higher",
      "remediationType": "update",
   }
}

