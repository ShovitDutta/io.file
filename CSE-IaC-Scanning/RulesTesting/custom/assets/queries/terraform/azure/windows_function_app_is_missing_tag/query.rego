package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not azureFunction.tags.itpmid
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not azureFunction.tags.costcenter

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not azureFunction.tags.dataclassification

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not azureFunction.tags.environmenttype

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_windows_function_app[name]
	not azureFunction.tags.sharedemailaddress

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_windows_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_windows_function_app[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_windows_function_app[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_windows_function_app[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_windows_function_app", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}