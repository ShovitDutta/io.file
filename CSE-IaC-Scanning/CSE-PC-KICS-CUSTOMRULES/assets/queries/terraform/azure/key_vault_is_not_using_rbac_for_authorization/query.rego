package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	not common_lib.valid_key(azureKeyVault, "enable_rbac_authorization")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].enable_rbac_authorization", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].enable_rbac_authorization should defined", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].enable_rbac_authorization is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name], []),
		"remediation": "Add enable_rbac_authorization field and set to true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	azureKeyVault.enable_rbac_authorization == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].enable_rbac_authorization", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].enable_rbac_authorization should be set to true", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].enable_rbac_authorization is set as false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "enable_rbac_authorization"], []),
		"remediation": "update enable_rbac_authorization enabled set to true",
		"remediationType": "update",
	}
}