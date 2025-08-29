package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureappgateway := input.document[i].resource.azurerm_application_gateway[name].tags
	not common_lib.valid_key(azureappgateway,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azureappgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappgateway := input.document[i].resource.azurerm_application_gateway[name].tags
	not common_lib.valid_key(azureappgateway,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azureappgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappgateway := input.document[i].resource.azurerm_application_gateway[name].tags
	not common_lib.valid_key(azureappgateway,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azureappgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappgateway := input.document[i].resource.azurerm_application_gateway[name].tags
	not common_lib.valid_key(azureappgateway,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azureappgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappgateway := input.document[i].resource.azurerm_application_gateway[name].tags
	not common_lib.valid_key(azureappgateway,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(azureappgateway, name),
		"searchKey": sprintf("azurerm_application_gateway[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}