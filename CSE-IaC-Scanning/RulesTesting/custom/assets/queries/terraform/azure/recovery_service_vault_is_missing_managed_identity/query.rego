package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name].identity
	count(resource) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_recovery_services_vault[name], name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].identity", [name]),
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].identity' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].identity' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "identity"], []),
		"remediation": "identity block should be defined with identity type",
		"remediationType": "addition",
	}
}