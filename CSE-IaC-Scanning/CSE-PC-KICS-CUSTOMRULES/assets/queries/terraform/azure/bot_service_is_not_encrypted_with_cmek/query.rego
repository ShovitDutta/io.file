package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.azurerm_bot_service_azure_bot[name]
	resource.cmk_key_vault_key_url == null

	result := {
		"documentId": doc.id,
		"resourceType": "azurerm_bot_service_azure_bot",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_bot_service_azure_bot[%s].cmk_key_vault_key_url", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_bot_service_azure_bot[%s].cmk_key_vault_key_url should have reference to CMEK url", [name]),
		"keyActualValue": sprintf("azurerm_bot_service_azure_bot[%s].cmk_key_vault_key_url is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_bot_service_azure_bot", name, "cmk_key_vault_key_url"], []),
		"remediation": "provide key vault key url",
		"remediationType": "update",
	}
}
