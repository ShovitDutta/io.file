package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	azurepostgresqlflexibleserver := input.document[i].resource.azurerm_postgresql_flexible_server[name]
	azurepostgresqlflexibleserver.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_flexible_server",
		"resourceName": tf_lib.get_resource_name(azurepostgresqlflexibleserver, name),
		"searchKey": sprintf("azurerm_postgresql_flexible_server[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_postgresql_flexible_server[%s].public_network_access_enabled should be defined and set it to false", [name]),
		"keyActualValue": sprintf("azurerm_postgresql_flexible_server[%s].public_network_access_enabled is set as true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_flexible_server", name, "public_network_access_enabled"], []),
		"remediation": "set public_network_access_enabled as false",
		"remediationType": "update",
	}	
}