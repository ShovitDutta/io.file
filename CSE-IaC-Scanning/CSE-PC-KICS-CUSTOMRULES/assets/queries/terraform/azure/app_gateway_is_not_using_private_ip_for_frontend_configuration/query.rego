package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].frontend_ip_configuration[k]
	not common_lib.valid_key(azgateway, "private_ip_address_allocation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address_allocation should be defined and private ip should be assigned", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address_allocation is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "frontend_ip_configuration"], []),
		"remediation": "add private_ip_address_allocation",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].frontend_ip_configuration[k]
	azgateway.private_ip_address_allocation == "Static"
	not common_lib.valid_key(azgateway, "private_ip_address")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address should be defined", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].frontend_ip_configuration.private_ip_address is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "frontend_ip_configuration"], []),
		"remediation": "add private_ip_address",
		"remediationType": "update",
	}	
}