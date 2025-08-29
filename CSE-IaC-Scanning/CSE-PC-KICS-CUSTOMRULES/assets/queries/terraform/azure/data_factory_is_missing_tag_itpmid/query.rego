package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	not common_lib.valid_key(azureDataFactory,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags"], []),
		"remediation": "itpmid = some_number",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	azureDataFactory.itpmid == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.itpmid", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.itpmid should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.itpmid is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags", "itpmid"], []),
		"remediation": "update itpmid",
		"remediationType": "update",
	}
}