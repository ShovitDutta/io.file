package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name]
	frontendipconfig := azurelb.frontend_ip_configuration[_]
	not common_lib.valid_key(frontendipconfig, "private_ip_address_allocation")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].frontend_ip_configuration", [name]),
		"issueType": "MissingConfiguration",
		"keyExpectedValue": sprintf("azurerm_lb[%s].frontend_ip_configuration.private_ip_address_allocation should be defined", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].frontend_ip_configuration.private_ip_address_allocation is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "frontend_ip_configuration"], []),
		"remediation": "defined private_ip_address_allocation - use only internal load balancer",
		"remediationType": "remove",
	}	
}