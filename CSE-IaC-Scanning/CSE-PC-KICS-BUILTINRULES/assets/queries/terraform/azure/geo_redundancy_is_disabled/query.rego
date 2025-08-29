package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This rule checks if the geo_redundant_backup_enabled property of an azurerm_postgresql_server resource is set to false.
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_postgresql_server[name]
	resource.geo_redundant_backup_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_postgresql_server[%s].geo_redundant_backup_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_postgresql_server.%s.geo_redundant_backup_enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_postgresql_server" ,name, "geo_redundant_backup_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
