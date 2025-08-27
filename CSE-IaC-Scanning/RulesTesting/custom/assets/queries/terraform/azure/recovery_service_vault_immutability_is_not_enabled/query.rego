package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	not common_lib.valid_key(resource, "immutability")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' should be defined and set Locked", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name], []),
		"remediation": "immutability should be defined and set it to Locked",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	resource.immutability == "Unlocked"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].immutability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' should be set to Locked", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' is set to UnLocked/Disabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "immutability"], []),
		"remediation": json.marshal({
			"before": "Unlocked",
			"after": "Locked"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	resource.immutability == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].immutability", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' should be set to Locked", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].immutability' is set to UnLocked/Disabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "immutability"], []),
		"remediation": json.marshal({
			"before": "Disabled",
			"after": "Locked"
		}),
		"remediationType": "replacement",
	}
}
