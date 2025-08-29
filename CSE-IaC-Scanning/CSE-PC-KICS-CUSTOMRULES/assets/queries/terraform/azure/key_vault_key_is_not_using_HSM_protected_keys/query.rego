package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azkeyvaultkey := input.document[i].resource.azurerm_key_vault_key[pname]
	not is_valid_key_type(azkeyvaultkey)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(azkeyvaultkey, pname),
		"searchKey": sprintf("azurerm_key_vault_key[%s].key_type", [pname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault_key[%s].key_type should be EC-HSM", [pname]),
		"keyActualValue": sprintf("azurerm_key_vault_key[%s].key_type is not EC-HSM", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", pname, "key_type"], []),
		"remediation": "update azurerm_key_vault_key should be EC-HSM",
		"remediationType": "update",
	}
}

is_valid_key_type(azkeyvaultkey) {
	azkeyvaultkey.key_type == "EC-HSM"
} else {
	azkeyvaultkey.key_type == "RSA-HSM"
}