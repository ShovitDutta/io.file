package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib




CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_mysql_flexible_server[name]

	resource.public_network_access == "Enabled"

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_mysql_flexible_server",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mysql_flexible_server[%s].public_network_access", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_mysql_flexible_server[%s].public_network_access should be set to Disabled", [name]),
		"keyActualValue": sprintf("azurerm_mysql_flexible_server[%s].public_network_access is set to Enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_mysql_flexible_server", name, "public_network_access"], []),
		"remediation": json.marshal({
			"before": "Enabled",
			"after": "Disabled"
		}),
		"remediationType": "replacement",
	}
}
