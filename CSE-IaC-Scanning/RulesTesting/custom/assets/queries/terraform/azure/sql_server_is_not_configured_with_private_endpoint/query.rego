package Cx
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    azureSQLServer := input.document[i].resource.azurerm_mssql_server[name]
    azureSQLServer.public_network_access_enabled == false
    azurePrivateEndPoint := input.document[i].resource.azurerm_private_endpoint[pname]
	not common_lib.valid_key(azurePrivateEndPoint,"private_service_connection")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_private_endpoint",
		"resourceName": tf_lib.get_resource_name(azurePrivateEndPoint, pname),
		"searchKey": sprintf("azurerm_private_endpoint[%s].private_service_connection", [pname]),
		"issueType": "InCorrectValue",
		"keyExpectedValue": sprintf("azurerm_private_endpoint[%s] should contain private service connection", [pname]),
		"keyActualValue": sprintf("azurerm_private_endpoint[%s].private_service_connection is undefined or null", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_private_endpoint", pname], []),
		"remediation": "define private service connection",
		"remediationType": "addition",
	}
}