package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# This rule checks if the expiration_date attribute of azurerm_key_vault_key is set to null or empty
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_key[name]
	
	common_lib.emptyOrNull(resource.expiration_date) = true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_key[%s].expiration_date", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_key_vault_key[%s].expiration_date' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_key_vault_key[%s].expiration_date' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_key_vault_key", name ,"expiration_date"], []),
		"remediation": "addition"
	}
}