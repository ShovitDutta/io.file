package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurecognitiveaccount := input.document[i].resource.azurerm_cognitive_account[name]
    azurecognitiveaccount.kind == "OpenAI"
	azuretags := azurecognitiveaccount.tags
	not common_lib.valid_key(azuretags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(azurecognitiveaccount, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.dataclassification should be defined", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.dataclassification is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "add and update dataclassification",
		"remediationType": "addition",
	}
}