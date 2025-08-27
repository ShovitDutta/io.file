package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	not common_lib.valid_key(cluster, "network_profile")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' should be set", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile' is undefined", [name]),
		"remediation": "network_profile {\n\t\tnetwork_policy = \"azure\"\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name].network_profile[k]
	not common_lib.valid_key(cluster, "network_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_kubernetes_cluster[name], name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name, "network_profile"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' should be set to either 'azure' or 'kubenet'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is undefined", [name]),
		"remediation": "network_policy = \"azure\"",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name].network_profile[k]
	policy := cluster.network_policy

	not validPolicy(policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].network_profile.network_policy", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name, "network_profile"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' should be either 'azure' or 'kubenet'", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].network_profile.network_policy' is %s", [name, policy]),
		"remediation": json.marshal({
			"before": sprintf("%s", [policy]),
			"after": "azure"
		}),
		"remediationType": "replacement",
	}
}

validPolicy("azure") = true

validPolicy("kubenet") = true
