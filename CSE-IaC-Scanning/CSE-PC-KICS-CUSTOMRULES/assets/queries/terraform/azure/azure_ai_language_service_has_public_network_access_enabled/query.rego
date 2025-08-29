package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_cognitive_account (TextAnalytics) resource has public_network_access_enabled set to false.

CxPolicy[result] {
	az_language_service := input.document[i].resource.azurerm_cognitive_account[name]
    az_language_service.kind == "TextAnalytics"

	# Check if public_network_access_enabled is set to true
	az_language_service.public_network_access_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_language_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}