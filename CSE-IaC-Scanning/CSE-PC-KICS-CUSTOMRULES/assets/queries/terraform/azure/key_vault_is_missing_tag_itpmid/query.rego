package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name].tags
	not common_lib.valid_key(azureKeyVault,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "tags"], []),
		"remediation": "add itpmid field",
		"remediationType": "addition",
	}
}