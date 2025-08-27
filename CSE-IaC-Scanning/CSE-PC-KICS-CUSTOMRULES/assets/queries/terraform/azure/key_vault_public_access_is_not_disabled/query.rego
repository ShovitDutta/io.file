package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	not common_lib.valid_key(azureKeyVault, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].public_network_access_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].public_network_access_enabled should be defined", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].public_network_access_enabled is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name], []),
		"remediation": "add public_network_access_enabled and value set to false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	azureKeyVault.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].public_network_access_enabled should be set to false to disable publc access", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].public_network_access_enabled is either set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "public_network_access_enabled"], []),
		"remediation": "update public_network_access_enabled value to false",
		"remediationType": "update",
	}
}