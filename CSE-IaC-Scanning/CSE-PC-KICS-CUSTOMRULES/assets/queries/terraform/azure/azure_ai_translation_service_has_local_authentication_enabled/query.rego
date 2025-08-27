package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_cognitive_account (Translation Services) resource has local_auth_enabled set to false.

CxPolicy[result] {
	az_translation_service := input.document[i].resource.azurerm_cognitive_account[name]
    az_translation_service.kind == "TextTranslation"

	# Check if local_auth_enabled is set to true
	az_translation_service.local_auth_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_translation_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].local_auth_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].local_auth_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].local_auth_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "local_auth_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}