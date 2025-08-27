package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	az_computervision_service := input.document[i].resource.azurerm_cognitive_account[name]
	az_computervision_service.kind == "ComputerVision"	
	not common_lib.valid_key(az_computervision_service.tags,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_computervision_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_computervision_service := input.document[i].resource.azurerm_cognitive_account[name]
	az_computervision_service.kind == "ComputerVision"	
	not common_lib.valid_key(az_computervision_service.tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_computervision_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_computervision_service := input.document[i].resource.azurerm_cognitive_account[name]
	az_computervision_service.kind == "ComputerVision"	
	not common_lib.valid_key(az_computervision_service.tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_computervision_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_computervision_service := input.document[i].resource.azurerm_cognitive_account[name]
	az_computervision_service.kind == "ComputerVision"	
	not common_lib.valid_key(az_computervision_service.tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_computervision_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	az_computervision_service := input.document[i].resource.azurerm_cognitive_account[name]
	az_computervision_service.kind == "ComputerVision"
	not common_lib.valid_key(az_computervision_service.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_computervision_service, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}