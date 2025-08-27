package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# This policy checks if the private cluster is enabled for AKS clusters in Azure.
CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	cluster.private_cluster_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].private_cluster_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].private_cluster_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "private_cluster_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
