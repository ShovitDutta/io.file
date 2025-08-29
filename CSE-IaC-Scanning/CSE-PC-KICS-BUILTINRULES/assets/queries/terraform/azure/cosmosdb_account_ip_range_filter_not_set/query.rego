package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# This rule checks if the IP range filter is set for Azure Cosmos DB accounts.
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_cosmosdb_account[name]
	
	common_lib.emptyOrNull(resource.ip_range_filter) = true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cosmosdb_account",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_cosmosdb_account[%s].ip_range_filter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_cosmosdb_account[%s].ip_range_filter' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_cosmosdb_account", name ,"ip_range_filter"], []),
		"remediation": "addition"
	}
}
