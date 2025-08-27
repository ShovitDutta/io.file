package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	not common_lib.valid_key(azureDataFactory,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags"], []),
		"remediation": "add environmenttype",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	azureDataFactory.environmenttype == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.environmenttype", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.environmenttype should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.environmenttype is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags", "environmenttype"], []),
		"remediation": "update environmenttype as e.g dev or staging or production",
		"remediationType": "update",
	}
}