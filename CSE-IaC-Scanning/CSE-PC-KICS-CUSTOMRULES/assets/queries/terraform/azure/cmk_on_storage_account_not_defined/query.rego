package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	storage := input.document[i].resource.azurerm_storage_account[name].customer_managed_key
	count(storage) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storage, name),
		"searchKey": sprintf("azurerm_storage_account[%s].customer_managed_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "customer_managed_key block should be defined",
		"keyActualValue": "customer_managed_key block is missing ",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "customer_managed_key"], []),
		"remediation": "add in a customer_managed_key block to the resource",
		"remediationType": "addition",
	}
}