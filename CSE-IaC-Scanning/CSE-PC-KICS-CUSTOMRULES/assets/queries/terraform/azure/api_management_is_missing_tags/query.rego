package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name].tags
	not common_lib.valid_key(azureapimgmt,"itpmid")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name].tags
	not common_lib.valid_key(azureapimgmt,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name].tags
	not common_lib.valid_key(azureapimgmt,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name].tags
	not common_lib.valid_key(azureapimgmt,"environmenttype")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name].tags
	not common_lib.valid_key(azureapimgmt,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(azureapimgmt, name),
		"searchKey": sprintf("azurerm_api_management[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_api_management[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}