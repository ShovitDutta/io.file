package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	not common_lib.valid_key(resource, "encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].encryption' should defined", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].encryption' is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "encryption"], []),
		"remediation": "encryption block should be defined",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name].encryption
	count(resource) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_recovery_services_vault[name], name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].encryption", [name]),
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].encryption block should be defined with key_id", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].encryption block is undefined with key_id for encryption", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "encryption"], []),
		"remediation": "Define key_id with CMEK reference",
		"remediationType": "update"
	}
}