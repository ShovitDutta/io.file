package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Check for azurerm_kubernetes_cluster resources that use disk encryption with customer-managed keys (CMEK)

# Policy to check if disk_encryption_set_id is not  defined 
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]    
    # Check disk_encryption_set_id is defined
    common_lib.emptyOrNull(akscluster.disk_encryption_set_id)
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].disk_encryption_set_must be defined", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].disk_encryption_set_id not defined or set as null", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].disk_encryption_set_id", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "disk_encryption_set_id"], []),
        "remediation": "Configure the disk_encryption_set_id in azurerm_kubernetes_cluster resource",
        "remediationType": "addition",
    } 
}

# Check host_encryption_enabled is not defined or null ( for azurerm 4.0.0 and above)
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    aks_default_node_pool := akscluster.default_node_pool[k]
    common_lib.emptyOrNull(aks_default_node_pool.host_encryption_enabled)    

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled must be defined and true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled not defined or set as null", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "default_node_pool","host_encryption_enabled"], []),
        "remediation": "Configure the default_node_pool.host_encryption_enabled in azurerm_kubernetes_cluster resource and set it to true.",
        "remediationType": "addition",
    } 
}

# Check enable_host_encryption is not defined or null ( for azurerm 3.0.0 and upto 3.117.1)
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    aks_default_node_pool := akscluster.default_node_pool[k]
    common_lib.emptyOrNull(aks_default_node_pool.enable_host_encryption)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption must be defined and true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption undefined or null", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "default_node_pool","enable_host_encryption"], []),
        "remediation": "Configure the default_node_pool.enable_host_encryption in azurerm_kubernetes_cluster resource and set it to true.",
        "remediationType": "addition",
    }
}

# for azurerm 4.0.0 and above

# disk_encryption_set_id is defined but host_encryption_enabled is false
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    # Check disk_encryption_set_id is defined and has value
    akscluster.disk_encryption_set_id != null
    # Check default_node_pool>host_encryption_enabled is defined and true
    aks_default_node_pool := akscluster.default_node_pool[k]
    aks_default_node_pool.host_encryption_enabled == false

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled should be true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled is set to false", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.host_encryption_enabled", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "default_node_pool","host_encryption_enabled"], []),
        "remediation": "Configure the default_node_pool.host_encryption_enabled in azurerm_kubernetes_cluster resource and set it to true.",
        "remediationType": "update",
    }
}

# for azurerm 3.0.0 and upto 3.117.1

# # disk_encryption_set_id is defined but enable_host_encryption is false
CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    
    akscluster.disk_encryption_set_id != null
    
    aks_default_node_pool := akscluster.default_node_pool[k]
    aks_default_node_pool.enable_host_encryption == false

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption should be true", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption is set to false", [name]),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].default_node_pool.enable_host_encryption", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "default_node_pool","enable_host_encryption"], []),
        "remediation": "Configure the default_node_pool.enable_host_encryption in azurerm_kubernetes_cluster resource and set it to true.",
        "remediationType": "update",
    }
}