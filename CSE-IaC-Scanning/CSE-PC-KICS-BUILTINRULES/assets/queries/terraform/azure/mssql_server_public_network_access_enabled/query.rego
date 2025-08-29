package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_mssql_server resource has the public_network_access_enabled attribute set to false.
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mssql_server[name]
	resource.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' should be false", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server[%s].public_network_access_enabled' is true", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_mssql_server" ,name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

