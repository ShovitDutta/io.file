package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not common_lib.valid_key(azureFunction, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled should be defined and set to false", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name], []),
		"remediation": "add the public_network_access_enabled and set to false",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	azureFunction.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].public_network_access_enabled is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "public_network_access_enabled"], []),
		"remediation": "public_network_access_enabled set to false",
		"remediationType": "update",
	}	
}