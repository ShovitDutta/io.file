package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurecognitiveaccount := input.document[i].resource.azurerm_cognitive_account[name]
    contains(azurecognitiveaccount.kind,"OpenAI")
	azurecognitiveaccount.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(azurecognitiveaccount, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled should be defined and set to false", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "public_network_access_enabled"], []),
		"remediation": "define public_network_access_enabled and set to false",
		"remediationType": "update",
	}
}