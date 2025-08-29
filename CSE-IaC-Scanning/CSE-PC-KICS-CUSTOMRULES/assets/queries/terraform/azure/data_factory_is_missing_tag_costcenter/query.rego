package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	not common_lib.valid_key(azureDataFactory,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.costcenter should be defined", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.costcenter is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags"], []),
		"remediation": "costcenter = costcenternumber",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name].tags
	azureDataFactory.costcenter == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].tags.costcenter", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].tags.costcenter should not be empty", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].tags.costcenter is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "tags", "costcenter"], []),
		"remediation": "update costcenter with proper costcenternumber",
		"remediationType": "update",
	}
}