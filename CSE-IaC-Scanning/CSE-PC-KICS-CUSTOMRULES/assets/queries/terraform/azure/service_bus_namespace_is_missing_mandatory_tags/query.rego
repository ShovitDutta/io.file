package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	az_service_bus_tags := input.document[i].resource.azurerm_servicebus_namespace[name].tags
	not common_lib.valid_key(az_service_bus_tags,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_tags, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_service_bus_tags := input.document[i].resource.azurerm_servicebus_namespace[name].tags
	not common_lib.valid_key(az_service_bus_tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_tags, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_service_bus_tags := input.document[i].resource.azurerm_servicebus_namespace[name].tags
	not common_lib.valid_key(az_service_bus_tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_tags, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_service_bus_tags := input.document[i].resource.azurerm_servicebus_namespace[name].tags
	not common_lib.valid_key(az_service_bus_tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_tags, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_service_bus_tags := input.document[i].resource.azurerm_servicebus_namespace[name].tags
	not common_lib.valid_key(az_service_bus_tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus_tags, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}