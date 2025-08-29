package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azbot := input.document[i].resource.azurerm_bot_service_azure_bot[name].tags
	not common_lib.valid_key(azbot,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(azbot, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.costcenter should be defined", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.costcenter is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "tags"], []),
		"remediation": "add costcenter",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azbot := input.document[i].resource.azurerm_bot_service_azure_bot[name].tags
	not common_lib.valid_key(azbot,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(azbot, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.itpmid should be defined", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.itpmid is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "tags"], []),
		"remediation": "add itpmid tag",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azbot := input.document[i].resource.azurerm_bot_service_azure_bot[name].tags
	not common_lib.valid_key(azbot,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(azbot, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.environmenttype should be defined", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.environmenttype is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "tags"], []),
		"remediation": "add environmenttype tag",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azbot := input.document[i].resource.azurerm_bot_service_azure_bot[name].tags
	not common_lib.valid_key(azbot,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(azbot, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.dataclassification should be defined", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.dataclassification is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "tags"], []),
		"remediation": "add dataclassification tag",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azbot := input.document[i].resource.azurerm_bot_service_azure_bot[name].tags
	not common_lib.valid_key(azbot,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(azbot, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.sharedemailaddress should be defined", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].tags.sharedemailaddress is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "tags"], []),
		"remediation": "add sharedemailaddress tag",
		"remediationType": "addition",
	}
}