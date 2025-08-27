package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurecognitiveaccount := input.document[i].resource.azurerm_cognitive_account[name]
    contains(azurecognitiveaccount.kind,"OpenAI")
	cognitivecustomermangerkey := azurecognitiveaccount.customer_managed_key
	count(cognitivecustomermangerkey) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(azurecognitiveaccount, name),
		"searchKey": sprintf("azurecognitiveaccount[%s].customer_managed_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].customer_managed_key should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].customer_managed_key is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "customer_managed_key"], []),
		"remediation": "define customer managed key",
		"remediationType": "addition",
	}
}