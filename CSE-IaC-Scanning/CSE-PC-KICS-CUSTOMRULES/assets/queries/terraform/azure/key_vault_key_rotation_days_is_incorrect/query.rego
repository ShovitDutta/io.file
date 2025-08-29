package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azkeyvaultkey := input.document[i].resource.azurerm_key_vault_key[pname].rotation_policy[j]
	azkeyvaultkey.automatic[k].time_after_creation != "P1Y"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_key_vault_key[pname], pname),
		"searchKey": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation", [pname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation should be 'P1Y'", [pname]),
		"keyActualValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation is not set to 'P1Y'", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", pname, "rotation_policy"], []),
		"remediation": "update azurerm_key_vault_key rotation policy after creation to 365 days",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azkeyvaultkey := input.document[i].resource.azurerm_key_vault_key[pname].rotation_policy[j]
	keyvaultkey := azkeyvaultkey.automatic[k]
	not common_lib.valid_key(keyvaultkey,"time_after_creation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_key_vault_key[pname], pname),
		"searchKey": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic", [pname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation should be 'P365D'", [pname]),
		"keyActualValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation does not exist", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", pname, "rotation_policy"], []),
		"remediation": "update azurerm_key_vault_key rotation policy after creation to 365 days",
		"remediationType": "update",
	}
}



CxPolicy[result] {
	azkeyvaultkey := input.document[i].resource.azurerm_key_vault_key[pname]
	keyvaultkey := azkeyvaultkey.rotation_policy[k]
	not common_lib.valid_key(keyvaultkey,"automatic")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(azkeyvaultkey, pname),
		"searchKey": sprintf("azurerm_key_vault_key[%s].rotation_policy", [pname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation should be 'P365D'", [pname]),
		"keyActualValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic does not exist", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", pname, "rotation_policy"], []),
		"remediation": "update azurerm_key_vault_key rotation policy after creation to 365 days",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	azkeyvaultkey := input.document[i].resource.azurerm_key_vault_key[pname]
	not common_lib.valid_key(azkeyvaultkey,"rotation_policy")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_key",
		"resourceName": tf_lib.get_resource_name(azkeyvaultkey, pname),
		"searchKey": sprintf("azurerm_key_vault_key[%s]", [pname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_key_vault_key[%s].rotation_policy.automatic.time_after_creation should be 'P365D'", [pname]),
		"keyActualValue": sprintf("azurerm_key_vault_key[%s].rotation_policy does not exist", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_key", pname], []),
		"remediation": "update azurerm_key_vault_key rotation policy after creation to 365 days",
		"remediationType": "update",
	}
}