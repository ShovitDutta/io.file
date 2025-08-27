package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	az_search_service_tags := input.document[i].resource.azurerm_search_service[name].tags
	not common_lib.valid_key(az_search_service_tags,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service_tags, name),
		"searchKey": sprintf("azurerm_search_service[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_search_service_tags := input.document[i].resource.azurerm_search_service[name].tags
	not common_lib.valid_key(az_search_service_tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service_tags, name),
		"searchKey": sprintf("azurerm_search_service[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_search_service_tags := input.document[i].resource.azurerm_search_service[name].tags
	not common_lib.valid_key(az_search_service_tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service_tags, name),
		"searchKey": sprintf("azurerm_search_service[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_search_service_tags := input.document[i].resource.azurerm_search_service[name].tags
	not common_lib.valid_key(az_search_service_tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service_tags, name),
		"searchKey": sprintf("azurerm_search_service[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_search_service_tags := input.document[i].resource.azurerm_search_service[name].tags
	not common_lib.valid_key(az_search_service_tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service_tags, name),
		"searchKey": sprintf("azurerm_search_service[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}