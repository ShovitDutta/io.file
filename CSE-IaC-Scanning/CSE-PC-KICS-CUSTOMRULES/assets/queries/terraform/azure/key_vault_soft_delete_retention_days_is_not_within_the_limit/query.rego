package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	azureKeyVault.soft_delete_retention_days < 7

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].soft_delete_retention_days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].soft_delete_retention_days should be set minimum of 7 days", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s]..soft_delete_retention_days is set to less than 7 days", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "soft_delete_retention_days"], []),
		"remediation": "update soft_delete_retention_days set to 7",
		"remediationType": "update",
	}
}