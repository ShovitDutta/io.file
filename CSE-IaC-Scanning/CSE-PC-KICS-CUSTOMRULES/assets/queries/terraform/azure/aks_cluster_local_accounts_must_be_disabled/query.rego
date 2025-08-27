package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Policy to check if local accounts are disabled in AKS clusters

# Check if values is not defined and value is null
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    common_lib.emptyOrNull(akscluster.local_account_disabled)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Missing Attribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled should be defined and not null", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled not defined and set as  null", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled", [name]),
        "searchValue": sprintf("%v", [akscluster.local_account_disabled]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "local_account_disabled"], []),
        "remediation": "update the local_account_disabled to true",
        "remediationType": "addition",
    }
}

# Check if value is not true for local_account_disabled
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    akscluster.local_account_disabled  == false

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled is set to %v", [name, akscluster.local_account_disabled]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].local_account_disabled", [name]),
        "searchValue": sprintf("%v", [akscluster.local_account_disabled]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "local_account_disabled"], []),
        "remediation": "update the local_account_disabled to true",
        "remediationType": "addition",
    }
}