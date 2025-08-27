package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	res := input.document[i].resource
	server := res.azurerm_app_configuration[name]
	server.public_network_access == "Disabled"
	not res.azurerm_private_endpoint[name]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_app_configuration",
		"resourceName": tf_lib.get_resource_name(server, name),
		"searchKey": sprintf("azurerm_app_configuration[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_private_endpoint[%s] resource should be defined", [name]),
		"keyActualValue": sprintf("azurerm_private_endpoint[%s] resource is undefined", [name]),
		"remediation": "define private service connection",
		"remediationType": "addition",
	}
}