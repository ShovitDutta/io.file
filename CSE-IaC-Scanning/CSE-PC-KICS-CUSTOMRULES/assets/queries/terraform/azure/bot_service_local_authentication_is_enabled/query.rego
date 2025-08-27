package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_bot_service_azure_bot[name]
	resource.local_authentication_enabled == true

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].local_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].local_authentication_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].local_authentication_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "local_authentication_enabled"], []),
		"remediation": "local_authentication_enabled should be set to false",
		"remediationType": "replacement",
	}
}
