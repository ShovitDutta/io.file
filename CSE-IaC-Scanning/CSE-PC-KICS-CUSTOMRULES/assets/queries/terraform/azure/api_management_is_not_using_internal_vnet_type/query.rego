package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	not azureapimgmt.virtual_network_type

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].virtual_network_type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].virtual_network_type should be defined and set it to Internal", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].virtual_network_type is not undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "virtual_network_type"], []),
		"remediation": "add virtual network type and set it to Internal",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.virtual_network_type != "Internal"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].virtual_network_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].virtual_network_type should be defined and set it to Internal", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].virtual_network_type is not set to Internal", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "virtual_network_type"], []),
		"remediation": "update the virtual network type set it to Internal",
		"remediationType": "Update",
	}
}