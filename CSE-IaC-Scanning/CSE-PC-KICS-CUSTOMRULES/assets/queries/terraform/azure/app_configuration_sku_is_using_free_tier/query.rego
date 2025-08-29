package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	not azureappconfig.sku
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].sku", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].sku should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].sku is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "tags"], []),
		"remediation": "add sku as a standard or premium tier",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	azureappconfig.sku == "free"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].sku", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].sku should set as standard or premium tier", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].sku is set as free tier", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "sku"], []),
		"remediation": "set sku as standard or premium",
		"remediationType": "update",
	}	
}

