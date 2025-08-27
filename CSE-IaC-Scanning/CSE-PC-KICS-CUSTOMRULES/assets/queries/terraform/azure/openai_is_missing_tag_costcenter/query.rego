package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurecognitiveaccount := input.document[i].resource.azurerm_cognitive_account[name]
    azurecognitiveaccount.kind == "OpenAI"
	azuretags := azurecognitiveaccount.tags
	not common_lib.valid_key(azuretags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(azurecognitiveaccount, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.costcenter should be defined", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.costcenter is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "add and update your cost center id e.g costcenter = 01231",
		"remediationType": "addition",
	}
}