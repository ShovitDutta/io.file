package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_bot_service_azure_bot[name]
	resource.public_network_access_enabled == true

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "public_network_access_enabled"], []),
		"remediation": "set the public network access enabled to false",
		"remediationType": "replacement",
	}
}
