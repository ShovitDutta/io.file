package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	not common_lib.valid_key(azureDataFactory,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags"], []),
		"remediation": "dataclassification = confidential or private or public",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	azureDataFactory.dataclassification == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.dataclassification", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.dataclassification should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.dataclassification is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags", "dataclassification"], []),
		"remediation": "update dataclassification",
		"remediationType": "update",
	}
}