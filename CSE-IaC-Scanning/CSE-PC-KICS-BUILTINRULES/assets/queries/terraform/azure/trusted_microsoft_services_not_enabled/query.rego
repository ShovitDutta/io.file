package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	nrules := input.document[i].resource.azurerm_storage_account[name].network_rules[k]
	not common_lib.valid_key(nrules, "bypass")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name),
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "MissingAttribute",
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account", name, "network_rules"], []),
		"keyExpectedValue": "'network_rules.bypass' should be defined and not null",
		"keyActualValue": "'network_rules.bypass' is undefined or null",
	}
}

CxPolicy[result] {
	nrules := input.document[i].resource.azurerm_storage_account[name].network_rules[k]
	some m
	nrules.bypass[m] != "AzureServices"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name),
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.bypass", [name]),
		"issueType": "IncorrectValue",
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account",name,"network_rules"], []),
		"keyExpectedValue": "'network_rules.bypass' should contain 'AzureServices'",
		"keyActualValue": "'network_rules.bypass' does not contain 'AzureServices'",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	some k
	network_rules.bypass[k] != "AzureServices"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(network_rules, name),
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].bypass", [name]),
		"issueType": "IncorrectValue",
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account_network_rules",name,"bypass"], []),
		"keyExpectedValue": "'bypass' should contain 'AzureServices'",
		"keyActualValue": "'bypass' does not contain 'AzureServices'",
	}
}