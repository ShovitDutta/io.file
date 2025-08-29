package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	not common_lib.valid_key(resource, "public_network_access_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name], []),
		"remediation": "public_network_access_enabled should be defined and set it to false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	resource.public_network_access_enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].public_network_access_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' should be set to false", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].public_network_access_enabled' is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
