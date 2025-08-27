package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not common_lib.valid_key(azureFunction, "https_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].https_only", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].https_only should be defined and set to true", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].https_only is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name], []),
		"remediation": "add the https_only and set to true",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	azureFunction.https_only == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].https_only", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].https_only should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].https_only is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "https_only"], []),
		"remediation": "https_only set to false",
		"remediationType": "update",
	}	
}