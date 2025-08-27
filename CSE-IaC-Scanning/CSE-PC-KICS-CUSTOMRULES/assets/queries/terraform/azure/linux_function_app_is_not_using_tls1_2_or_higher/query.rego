package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_linux_function_app[name].site_config[j]
	to_number(azureFunction.minimum_tls_version) < 1.2

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_linux_function_app",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_linux_function_app[name], name),
		"searchKey": sprintf("azurerm_linux_function_app[%s].site_config.minimum_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_linux_function_app[%s].site_config.minimum_tls_version should be set to 1.2 or higher", [name]),
		"keyActualValue": sprintf("azurerm_linux_function_app[%s].site_config.minimum_tls_version is not set to 1.2 or higher", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_function_app", name, "site_config", "minimum_tls_version"], []),
		"remediation": "set the minimum_tls_version to 1.2 or higher",
		"remediationType": "update",
	}	
}
