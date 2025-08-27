package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules[k]

	network_rules.ip_rules[l] == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name),
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "network_rules.ip_rules should not contain 0.0.0.0/0",
		"keyActualValue": "network_rules.ip_rules contains 0.0.0.0/0",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "network_rules"], []),
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules[k]
	not common_lib.valid_key(network_rules, "ip_rules")
	network_rules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name),
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules.ip_rules' should be defined and not null",
		"keyActualValue": "'network_rules.default_action' is 'Allow' and 'network_rules.ip_rules' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "network_rules"], []),
	}
}

CxPolicy[result] {
	rules := input.document[i].resource.azurerm_storage_account_network_rules[name]

	rules.ip_rules[l] == "0.0.0.0/0"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(rules, name),
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].ip_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_storage_account_network_rules[%s] -ip_rules[%d] should not contain 0.0.0.0/0", [l]),
		"keyActualValue": sprintf("azurerm_storage_account_network_rules[%s] -ip_rules[%d] contains 0.0.0.0/0", [l]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name, "ip_rules"], [l]),
	}
}

CxPolicy[result] {
	rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	
	rules.default_action == "Allow"
	common_lib.emptyOrNull(rules.ip_rules) = true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(rules, name),
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_storage_account_network_rules[%s] - 'ip_rules' should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_storage_account_network_rules[%s] - 'default_action' is set to 'Allow' and 'ip_rules' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name, "ip_rules"], []),
	}
}

