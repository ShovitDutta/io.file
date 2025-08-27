package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[lbname]
	common_lib.valid_key(azurelb, "frontend_ip_configuration")
	azurenetworksg := input.document[i].resource.azurerm_network_security_group[name]
	not common_lib.valid_key(azurenetworksg,"security_rule")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_security_group",
		"resourceName": tf_lib.get_resource_name(azurenetworksg, name),
		"searchKey": sprintf("azurerm_network_security_group[%s].security_rule", [name]),
		"issueType": "MissingConfiguratoin",
		"keyExpectedValue": sprintf("azurerm_network_security_group[%s].security_rule should be defined", [name]),
		"keyActualValue": sprintf("azurerm_network_security_group[%s].security_rule is undefiend", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_security_group", name], []),
		"remediation": "add networksecurity group with security rule",
		"remediationType": "addition",
	}	
}