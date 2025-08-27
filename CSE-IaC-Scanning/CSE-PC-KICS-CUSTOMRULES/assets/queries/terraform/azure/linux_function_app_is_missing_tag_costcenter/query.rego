package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_linux_function_app[name].tags
	not common_lib.valid_key(resource,"costcenter")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_linux_function_app",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_linux_function_app[name], name),
		"searchKey": sprintf("azurerm_linux_function_app[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_linux_function_app[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_linux_function_app[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_function_app", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}