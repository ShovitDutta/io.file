package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurepostgresqlflexibleserver := input.document[i].resource.azurerm_postgresql_flexible_server[name]
	not common_lib.valid_key(azurepostgresqlflexibleserver,"customer_managed_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azurepostgresqlflexibleserver, name),
		"searchKey": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key should be defined", [name]),
		"keyActualValue": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_flexible_server", name, "customer_managed_key"], []),
		"remediation": "configure customer_managed_key for encryption",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azurepostgresqlflexibleserver := input.document[i].resource.azurerm_postgresql_flexible_server[name].customer_managed_key
	count(azurepostgresqlflexibleserver) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azurepostgresqlflexibleserver, name),
		"searchKey": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key should be defined", [name]),
		"keyActualValue": sprintf("azurerm_postgresql_flexible_server[%s].customer_managed_key is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_flexible_server", name, "customer_managed_key"], []),
		"remediation": "define customer_managed_key for encryption",
		"remediationType": "addition",
	}	
}