package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_servicebus_namespace resource has local_auth_enabled set to false.

CxPolicy[result] {
	az_service_bus := input.document[i].resource.azurerm_servicebus_namespace[name]

	# Check if local_auth_enabled is set to true
	az_service_bus.local_auth_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].local_auth_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].local_auth_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].local_auth_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "local_auth_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}