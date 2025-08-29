package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This query checks if the azurerm_mssql_server_extended_auditing_policy is enabled
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_mssql_server_extended_auditing_policy[name]
	resource.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_mssql_server_extended_auditing_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_mssql_server_extended_auditing_policy[%s].enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_mssql_server_extended_auditing_policy[%s].enabled' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_mssql_server_extended_auditing_policy[%s].enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_mssql_server_extended_auditing_policy" ,name, "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}