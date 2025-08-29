package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#  This rule checks if the Azure Service Bus Namespace is not using the premium SKU.
CxPolicy[result] {
	az_service_bus := input.document[i].resource.azurerm_servicebus_namespace[name]
	lower(az_service_bus.sku) != "premium"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(az_service_bus, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s].sku", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_servicebus_namespace[%s].sku should have premium tier", [name]),
		"keyActualValue": sprintf("azurerm_servicebus_namespace[%s].sku is not premium", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name, "sku"], []),
		"remediation": "update sku value to premium",
		"remediationType": "update",
	}
}