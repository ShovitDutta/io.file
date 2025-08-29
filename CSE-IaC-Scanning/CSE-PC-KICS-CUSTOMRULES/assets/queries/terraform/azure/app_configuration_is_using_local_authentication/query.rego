package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	not common_lib.valid_key(azureappconfig, "local_auth_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].local_auth_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].local_auth_enabled should be defined and set as false", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].local_auth_enabled is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name], []),
		"remediation": "add local_auth_enabled set as false",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureappconfig := input.document[i].resource.azurerm_app_configuration[name]
	azureappconfig.local_auth_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(azureappconfig, name),
		"searchKey": sprintf("azurerm_app_configuration[%s].local_auth_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_app_configuration[%s].local_auth_enabled should set as false", [name]),
		"keyActualValue": sprintf("azurerm_app_configuration[%s].local_auth_enabled is set as true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_app_configuration", name, "local_auth_enabled"], []),
		"remediation": "set local_auth_enabled set as false",
		"remediationType": "update",
	}	
}

