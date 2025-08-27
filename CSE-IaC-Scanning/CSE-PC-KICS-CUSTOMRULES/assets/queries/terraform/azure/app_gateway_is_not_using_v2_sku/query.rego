package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].sku[k]
	azgateway.name != "Standard_v2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].sku.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].sku.name should be defined and sku name set to Standard_v2", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].sku.name is not set to Standard_v2", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "sku", "name"], []),
		"remediation": "sku name set to Standard_v2",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].sku[k]
	azgateway.tier != "Standard_v2"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].sku.tier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].sku.tier should be defined and sku name set to Standard_v2", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].sku.tier is not set to Standard_v2", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "sku", "tier"], []),
		"remediation": "sku tier set to Standard_v2",
		"remediationType": "update",
	}	
}