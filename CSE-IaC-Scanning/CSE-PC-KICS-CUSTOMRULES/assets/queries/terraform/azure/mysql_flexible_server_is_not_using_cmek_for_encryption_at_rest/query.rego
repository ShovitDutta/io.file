package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mysql_flexible_server[name]
	
	not common_lib.valid_key(resource, "customer_managed_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_mysql_flexible_server[%s].customer_managed_key' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_flexible_server[%s].customer_managed_key' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name], []),
		"remediation": "define customer_managed_key",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mysql_flexible_server[name].customer_managed_key
	count(resource) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].customer_managed_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mysql_flexible_server[%s].customer_managed_key block with key_vault_key_id should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_mysql_flexible_server[%s].customer_managed_key block with key_vault_key_id is undefined or empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "customer_managed_key"], []),
		"remediation": "provide reference to key_vault_key_id under customer managed key block",
		"remediationType": "update",
	}
}
