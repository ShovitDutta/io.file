package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azresource := input.document[i].resource.azurerm_redis_cache[name]
	azresource.public_network_access_enabled == false
	azprivateendpoint := input.document[i].resource.azurerm_private_endpoint[pname].private_service_connection[j]
	not common_lib.valid_key(azprivateendpoint,"private_connection_resource_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_private_endpoint",
		"resourceName": tf_lib.get_resource_name(azprivateendpoint, pname),
		"searchKey": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id", [pname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id should be defined", [pname]),
		"keyActualValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id is undefined", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_private_endpoint", pname, "private_service_connection"], []),
		"remediation": "Add private_connection_resource_id under Private connection block",
		"remediationType": "update",
	}
}