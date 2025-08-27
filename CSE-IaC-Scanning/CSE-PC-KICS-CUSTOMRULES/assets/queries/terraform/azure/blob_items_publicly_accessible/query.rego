package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	storage := input.document[i].resource.azurerm_storage_account[name]
	not storage.allow_nested_items_to_be_public
	storage.allow_nested_items_to_be_public == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storage, name),
		"searchKey": sprintf("azurerm_storage_account[%s].allow_nested_items_to_be_public", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'allow_nested_items_to_be_public' should be set to false",
		"keyActualValue": "'allow_nested_items_to_be_public' is set to true or undefined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "allow_nested_items_to_be_public"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}