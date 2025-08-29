package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	not common_lib.valid_key(azureKeyVault, "purge_protection_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].purge_protection_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].purge_protection_enabled should be defined", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].purge_protection_enabled is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name], []),
		"remediation": "define purge protection enabled and set to true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	azureKeyVault.purge_protection_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].purge_protection_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].purge_protection_enabled should be set to true", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].purge_protection_enabled is set as false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "purge_protection_enabled"], []),
		"remediation": "update purge protection enabled set to true",
		"remediationType": "update",
	}
}