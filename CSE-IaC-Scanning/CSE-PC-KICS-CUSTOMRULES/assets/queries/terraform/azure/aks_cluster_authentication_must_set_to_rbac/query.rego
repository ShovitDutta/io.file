package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Check if role_based_access_control_enabled is set to false

CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check role_based_access_control_enabled is set to false
    akscluster.role_based_access_control_enabled == false
    
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control_enabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control_enabled is set to false", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].role_based_access_control_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "role_based_access_control_enabled"], []),
        "remediation": "update the role_based_access_control_enabled to true and azure_active_directory_role_based_access_control > azure_rbac_enabled to true",
        "remediationType": "addition",
    }
}

# Check if azure_active_directory_role_based_access_control is not defined
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    az_ad_rbac := akscluster.azure_active_directory_role_based_access_control # Get azure_active_directory_role_based_access_control block
    count(az_ad_rbac) == 0

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Missing Attribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control should be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control is not defined", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "azure_active_directory_role_based_access_control"], []),
        "remediation": "Configure the azure_active_directory_role_based_access_control block in azurerm_kubernetes_cluster resource to enable AAD RBAC.",
        "remediationType": "addition",
    }
}

# Check if azure_active_directory_role_based_access_control > azure_rbac_enabled is set to false
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check azure_active_directory_role_based_access_control > azure_rbac_enabled is set to false
    az_ad_rbac := akscluster.azure_active_directory_role_based_access_control[k]
    az_ad_rbac.azure_rbac_enabled == false
    
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Incorrect Value",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled is set to false", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "azure_active_directory_role_based_access_control", "azure_rbac_enabled"], []),
        "remediation": "update the azure_active_directory_role_based_access_control > azure_rbac_enabled to true",
        "remediationType": "addition",
    }
}

# Check if role_based_access_control_enabled is set to true and azure_active_directory_role_based_access_control > azure_rbac_enabled is not defined
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]    
    akscluster.role_based_access_control_enabled == true
    az_ad_rbac := akscluster.azure_active_directory_role_based_access_control[k]
    # Check if azure_rbac_enabled is not defined 
    common_lib.emptyOrNull(az_ad_rbac.azure_rbac_enabled)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "Missing Attribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled should be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled is not defined or false", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].azure_active_directory_role_based_access_control.azure_rbac_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "azure_active_directory_role_based_access_control", "azure_rbac_enabled"], []),
        "remediation": "Configure the azure_active_directory_role_based_access_control block in azurerm_kubernetes_cluster resource to enable AAD RBAC.",
        "remediationType": "addition",
    }
} 