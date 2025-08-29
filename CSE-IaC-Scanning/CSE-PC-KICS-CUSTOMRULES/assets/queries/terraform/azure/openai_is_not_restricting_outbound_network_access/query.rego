package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurecognitiveaccount := input.document[i].resource.azurerm_cognitive_account[name]
    contains(azurecognitiveaccount.kind,"OpenAI")
	azurecognitiveaccount.outbound_network_access_restricted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(azurecognitiveaccount, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].outbound_network_access_restricted", [name]),
		"issueType": "Incorrectvalue",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].outbound_network_access_restricted should be set to true", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].outbound_network_access_restricted is set as false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "outbound_network_access_restricted"], []),
		"remediation": "update outbound_network_access_restricted set to true",
		"remediationType": "update",
	}
}