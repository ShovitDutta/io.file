package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFunction := input.document[i].resource.azurerm_linux_function_app[name].tags
	not common_lib.valid_key(azureFunction,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_linux_function_app",
		"resourceName": tf_lib.get_resource_name(azureFunction, name),
		"searchKey": sprintf("azurerm_linux_function_app[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_linux_function_app[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_linux_function_app[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_linux_function_app", name, "tags"], []),
		"remediation": "add the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}