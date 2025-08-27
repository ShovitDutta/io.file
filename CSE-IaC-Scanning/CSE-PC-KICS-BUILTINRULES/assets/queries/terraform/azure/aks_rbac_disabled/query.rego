package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This rule checks if the role-based access control (RBAC) is enabled for Azure Kubernetes Service (AKS).

CxPolicy[result] {
	cluster := input.document[i].resource.azurerm_kubernetes_cluster[name]

	cluster.role_based_access_control_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(cluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_kubernetes_cluster", name ,"role_based_access_control_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control_enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_kubernetes_cluster[%s].role_based_access_control_enabled' is not set to true", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


