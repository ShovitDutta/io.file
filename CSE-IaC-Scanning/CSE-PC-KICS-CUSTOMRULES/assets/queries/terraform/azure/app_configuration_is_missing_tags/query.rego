package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name].tags
	not common_lib.valid_key(azureappconfig,"itpmid")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name].tags
	not common_lib.valid_key(azureappconfig,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name].tags
	not common_lib.valid_key(azureappconfig,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name].tags
	not common_lib.valid_key(azureappconfig,"environmenttype")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name].tags
	not common_lib.valid_key(azureappconfig,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}