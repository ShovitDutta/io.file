package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# check if automatic_upgrade_channel and node_os_upgrade_channel not defined

CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check automatic_upgrade_channel is not defined
    common_lib.emptyOrNull(akscluster.automatic_upgrade_channel)
    # Check node_os_upgrade_channel is not defined
    lower(akscluster.node_os_upgrade_channel) == "none"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Missing Attribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel and node_os_upgrade_channel should be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel and node_os_upgrade_channel are not defined", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "automatic_upgrade_channel"], []),
        "remediation": "Configure the automatic_upgrade_channel and node_os_upgrade_channel in azurerm_kubernetes_cluster resource.",
        "remediationType": "addition",
    }
}

# Check if automatic_upgrade_channel is defined and node_os_upgrade_channel is not defined
CxPolicy[result] {
    
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check automatic_upgrade_channel is not defined
    not common_lib.emptyOrNull(akscluster.automatic_upgrade_channel)
    # Check node_os_upgrade_channel is not defined
    lower(akscluster.node_os_upgrade_channel) == "none"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].node_os_upgrade_channel should be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].node_os_upgrade_channel is not defined", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].node_os_upgrade_channel", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "node_os_upgrade_channel"], []),
        "remediation": "Configure the node_os_upgrade_channel in azurerm_kubernetes_cluster resource.",
        "remediationType": "addition",
    }
}

# Check if automatic_upgrade_channel is not defined and node_os_upgrade_channel is defined

CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check automatic_upgrade_channel is not defined
    common_lib.emptyOrNull(akscluster.automatic_upgrade_channel)
    # Check node_os_upgrade_channel is defined
    not lower(akscluster.node_os_upgrade_channel) == "none"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel should be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel is not defined", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].automatic_upgrade_channel", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "automatic_upgrade_channel"], []),
        "remediation": "Configure the automatic_upgrade_channel in azurerm_kubernetes_cluster resource.",
        "remediationType": "addition",
    }
}