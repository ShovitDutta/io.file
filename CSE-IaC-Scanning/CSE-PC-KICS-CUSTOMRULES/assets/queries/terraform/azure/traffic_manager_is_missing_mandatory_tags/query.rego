package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	not common_lib.valid_key(resource.tags,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_traffic_manager_profile[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_traffic_manager_profile[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	not common_lib.valid_key(resource.tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_traffic_manager_profile[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_traffic_manager_profile[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	not common_lib.valid_key(resource.tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_traffic_manager_profile[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_traffic_manager_profile[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	not common_lib.valid_key(resource.tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_traffic_manager_profile[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_traffic_manager_profile[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	not common_lib.valid_key(resource.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_traffic_manager_profile[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_traffic_manager_profile[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}