package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureKeyVault := input.document[i].resource.azurerm_key_vault[name]
	azureKeyVault.sku_name != "premium"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault",
		"resourceName": tf_lib.get_resource_name(azureKeyVault, name),
		"searchKey": sprintf("azurerm_key_vault[%s].sku_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault[%s].sku_name should have premium tier", [name]),
		"keyActualValue": sprintf("azurerm_key_vault[%s].sku_name is not premium", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name, "sku_name"], []),
		"remediation": "update sku_name value to premium",
		"remediationType": "update",
	}
}