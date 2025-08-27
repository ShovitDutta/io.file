package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	resource.public_network_access_enabled == false
	azprivateendpoint := input.document[i].resource.azurerm_private_endpoint[pname].private_service_connection[j]
	not common_lib.valid_key(azprivateendpoint,"private_connection_resource_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_private_endpoint",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_private_endpoint[pname], pname),
		"searchKey": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id", [pname]),
		"issueType": "InCorrectValue",
		"keyExpectedValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id should contain azurerm_recovery_services_vault", [pname]),
		"keyActualValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id is undefined or null", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_private_endpoint", pname, "private_service_connection"], []),
		"remediation": "define end point for recovery_vault under private service connection",
		"remediationType": "addition",
	}
}
