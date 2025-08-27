package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Function to check if kind is either CustomVision.Training or CustomVision.Prediction
is_custom_vision(kind) {
	kind == "CustomVision.Training"
}

is_custom_vision(kind) {
	kind == "CustomVision.Prediction"
}


CxPolicy[result] {
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
	is_custom_vision(az_custom_vision.kind)
	not common_lib.valid_key(az_custom_vision.tags,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
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
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
	is_custom_vision(az_custom_vision.kind)
	not common_lib.valid_key(az_custom_vision.tags,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
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
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
	is_custom_vision(az_custom_vision.kind)	
	not common_lib.valid_key(az_custom_vision.tags,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
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
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
	is_custom_vision(az_custom_vision.kind)	
	not common_lib.valid_key(az_custom_vision.tags,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
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
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
	is_custom_vision(az_custom_vision.kind)
	not common_lib.valid_key(az_custom_vision.tags,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}