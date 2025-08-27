package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# This query checks if the infrastructure encryption is enabled for Azure PostgreSQL servers.
CxPolicy[result] {
	pg := input.document[i].resource.azurerm_postgresql_server[name]

	pg.infrastructure_encryption_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_server",
		"resourceName": tf_lib.get_resource_name(pg, name),
		"searchKey": sprintf("azurerm_postgresql_server[%s].infrastructure_encryption_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_server[%s].infrastructure_encryption_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_postgresql_server[%s].infrastructure_encryption_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_postgresql_server", name, "infrastructure_encryption_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
