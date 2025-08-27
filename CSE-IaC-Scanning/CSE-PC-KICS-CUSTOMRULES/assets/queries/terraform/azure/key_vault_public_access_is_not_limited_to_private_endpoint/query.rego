package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	tfpresource := input.document[i].resource
	azureKeyVault := tfpresource.azurerm_key_vault[name]
	azureKeyVault.public_network_access_enabled == false
	azprivateendpointconn := tfpresource.azurerm_private_endpoint[pname].private_service_connection[k]
	azprivateendpointconn.subresource_names[m] == "vault"
	not contains(azprivateendpointconn.private_connection_resource_id, "Microsoft.KeyVault")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_private_endpoint",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_private_endpoint[pname], pname),
		"searchKey": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id", [pname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id should reference to azure keyvault", [pname]),
		"keyActualValue": sprintf("azurerm_private_endpoint[%s].private_service_connection.private_connection_resource_id does not have reference to azure keyvault", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_private_endpoint", name, "private_service_connection", "private_connection_resource_id"], []),
		"remediation": "Private connection resource id should have reference to azure keyvault",
		"remediationType": "update",
	}
}