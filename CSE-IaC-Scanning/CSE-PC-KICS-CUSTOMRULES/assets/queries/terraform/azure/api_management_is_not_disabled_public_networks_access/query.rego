package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	not common_lib.valid_key(azureapimgmt,"public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].public_network_access_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].public_network_access_enabled should be defined and set it to Internal", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].public_network_access_enabled is not undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "public_network_access_enabled"], []),
		"remediation": "define public network access and set to false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].public_network_access_enabled should be defined and set it to false", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "public_network_access_enabled"], []),
		"remediation": "public network access enabled should be set to false",
		"remediationType": "Update",
	}
}
