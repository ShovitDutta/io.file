package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azurelb := input.document[i].resource.azurerm_lb[name]
	azurelb.sku != "Standard"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_lb",
		"resourceName": tf_lib.get_resource_name(azurelb, name),
		"searchKey": sprintf("azurerm_lb[%s].sku", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_lb[%s].sku should use Standard Sku", [name]),
		"keyActualValue": sprintf("azurerm_lb[%s].sku is not using Standard Sku", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_lb", name, "sku"], []),
		"remediation": "update sku to Standard",
		"remediationType": "update",
	}	
}