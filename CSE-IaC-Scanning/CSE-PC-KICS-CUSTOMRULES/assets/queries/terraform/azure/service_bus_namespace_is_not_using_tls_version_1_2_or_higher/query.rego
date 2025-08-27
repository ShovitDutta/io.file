package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	az_service_bus := input.document[i].resource.azurerm_servicebus_namespace[name]
	to_number(az_service_bus.minimum_tls_version) < 1.2

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].minimum_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].minimum_tls_version should be set to 1.2 or higher", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].minimum_tls_version is not set to 1.2 or higher", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "minimum_tls_version"], []),
		"remediation": "set the minimum_tls_version to 1.2 or higher",
		"remediationType": "update",
	}	
}