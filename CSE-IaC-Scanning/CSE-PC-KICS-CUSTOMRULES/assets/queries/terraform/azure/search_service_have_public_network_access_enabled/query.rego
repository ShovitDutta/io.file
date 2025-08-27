package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_search_service resource has public_network_access_enabled set to true.

CxPolicy[result] {
	az_search_service := input.document[i].resource.azurerm_search_service[name]

	# Check if public_network_access_enabled is set to true
	az_search_service.public_network_access_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_search_service",
		"resourceName": tf_lib.get_resource_name(az_search_service, name),
		"searchKey": sprintf("azurerm_search_service[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_search_service[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_search_service[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_search_service", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}