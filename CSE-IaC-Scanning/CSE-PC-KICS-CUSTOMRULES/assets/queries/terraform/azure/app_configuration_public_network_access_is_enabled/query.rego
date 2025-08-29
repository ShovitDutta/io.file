package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	not azureappconfig.public_network_access
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].public_network_access", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].public_network_access should be defined and set as Disabled", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].public_network_access is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name], []),
		"remediation": "add public_network_access set as Disabled",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	azureappconfig.public_network_access == "Enabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].public_network_access", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].public_network_access should set as Disabled", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].public_network_access is set as Enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "public_network_access"], []),
		"remediation": "set public_network_access as Disabled",
		"remediationType": "update",
	}	
}