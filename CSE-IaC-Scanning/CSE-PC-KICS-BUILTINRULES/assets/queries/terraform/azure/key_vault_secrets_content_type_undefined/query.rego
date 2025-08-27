package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# This rule checks if the content_type attribute of azurerm_key_vault_secret is set to null or empty
CxPolicy[result] {
	resource := input.document[i].resource.azurerm_key_vault_secret[name]

	common_lib.emptyOrNull(resource.content_type) = true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_key_vault_secret[%s].content_type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_key_vault_secret[%s].content_type' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_key_vault_secret[%s].content_type' is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_key_vault_secret", name ,"content_type"], []),
		"remediation": "addition"
	}
}
