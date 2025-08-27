package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {

	# after azurerm 3.0

	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	cluster.azure_policy_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].azure_policy_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].azure_policy_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].azure_policy_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "azure_policy_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	common_lib.emptyOrNull(cluster.azure_policy_enabled) # after version 3.0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s]' should use Azure Policies", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s]' does not use Azure Policies", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name,"azure_policy_enabled"], []),
		"remediation": "Configure the azure_policy_enabled in azurerm_kubernetes_cluster resource and set it to true.",
		"remediationType": "addition",
	}
}
