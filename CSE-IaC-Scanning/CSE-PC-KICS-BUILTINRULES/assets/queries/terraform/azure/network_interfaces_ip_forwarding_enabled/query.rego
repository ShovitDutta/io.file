package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This rule checks if the azurerm_network_interface resource has the ip_forwarding_enabled attribute set to false.
CxPolicy[result] {
	network_interface := input.document[i].resource.azurerm_network_interface[name]

	network_interface.ip_forwarding_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_interface",
		"resourceName": tf_lib.get_resource_name(network_interface, name),
		"searchKey": sprintf("azurerm_network_interface[%s].ip_forwarding_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_network_interface[%s].ip_forwarding_enabled' should be set to false or undefined", [name]),
		"keyActualValue": sprintf("'azurerm_network_interface[%s].ip_forwarding_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_interface", name, "ip_forwarding_enabled"], []),
		"remediation": "ip_forwarding_enabled = false",
		"remediationType": "addition",
	}
}
