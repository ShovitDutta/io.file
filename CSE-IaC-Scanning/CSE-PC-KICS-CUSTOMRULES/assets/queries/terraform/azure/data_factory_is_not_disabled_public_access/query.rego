package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name]
	not common_lib.valid_key(azureDataFactory,"public_network_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].public_network_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].public_network_enabled should be defined and set it to false", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].public_network_enabled is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name], []),
		"remediation": "define and set public_network_enabled = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureDataFactory := input.document[i].resource.azurerm_data_factory[name]
	azureDataFactory.public_network_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_factory",
		"resourceName": tf_lib.get_resource_name(azureDataFactory, name),
		"searchKey": sprintf("azurerm_data_factory[%s].public_network_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_data_factory[%s].public_network_enabled should be set it to false", [name]),
		"keyActualValue": sprintf("azurerm_data_factory[%s].public_network_enabled is not set it to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "public_network_enabled"], []),
		"remediation": "set public_network_enabled = false",
		"remediationType": "update",
	}
}