package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Policy to check if local accounts are disabled in AKS clusters

# Check check if private_cluster_enabled is false and private_cluster_public_fqdn_enabled is true
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]  
    not akscluster.private_cluster_enabled
    akscluster.private_cluster_public_fqdn_enabled == true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s] should have private_cluster_enabled set to true and private_cluster_public_fqdn_enabled set to false", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s] has private_cluster_enabled set to false and private_cluster_public_fqdn_enabled set to true", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].private_cluster_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "private_cluster_enabled"], []),
        "remediation": "update the private_cluster_enabled to true and private_cluster_public_fqdn_enabled to false",
        "remediationType": "addition",
    }
}



# Check check if private_cluster_enabled is true and private_cluster_public_fqdn_enabled is true
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    akscluster.private_cluster_enabled == true
    akscluster.private_cluster_public_fqdn_enabled == true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s] should have private_cluster_public_fqdn_enabled set to false", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s] has private_cluster_public_fqdn_enabled set to true", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].private_cluster_public_fqdn_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "private_cluster_public_fqdn_enabled"], []),
        "remediation": "update the private_cluster_public_fqdn_enabled to false",
        "remediationType": "addition",
    }
}

