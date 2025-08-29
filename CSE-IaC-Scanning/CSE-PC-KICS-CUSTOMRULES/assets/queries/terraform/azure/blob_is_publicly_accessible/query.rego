package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	storage_account := input.document[i].resource.azurerm_storage_account[name]
	storage_account.public_network_access_enabled == true
	storage_account.allow_nested_items_to_be_public == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storage_account, name),
		"searchKey": sprintf("azurerm_storage_account.public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_storage_account.public_network_access_enabled and allow nested items to be public should be set to false",
		"keyActualValue": "azurerm_storage_account.public_network_access_enabled and allow nested items to be public is set as true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "allow_nested_items_to_be_public"], [])
	}
}