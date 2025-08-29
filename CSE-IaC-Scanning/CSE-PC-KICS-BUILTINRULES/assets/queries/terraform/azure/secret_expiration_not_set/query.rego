package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# This rule checks if the azurerm_key_vault_secret resource has expiration_date set
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_secret[name]	
	common_lib.emptyOrNull(resource.expiration_date) = true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_secret[%s].expiration_date", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_key_vault_secret[%s].expiration_date' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_key_vault_secret[%s].expiration_date' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_key_vault_secret", name ,"expiration_date"], []),
		"remediation" : "Define expiration_date for Key Vault Secret",
		"remediationType": "addition"
	}
}
