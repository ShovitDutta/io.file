package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
	aks_kms :=  akscluster.key_management_service
	count(aks_kms) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].key_management_service", [name]),
		"issueType": "Missing Attribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].key_management_service should be defined", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].key_management_service is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "key_management_service"], []),
		"remediation": "Configure the key_management_service block in azurerm_kubernetes_cluster resource to enable KMS encryption.",
		"remediationType": "addition",
	}	
}


# Check key_vault network access is public 

CxPolicy[result] {
    akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name]
    kms_configuration := akscluster.key_management_service[k]
    count(kms_configuration) > 0
    lower(kms_configuration.key_vault_network_access) == "public"

    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_kubernetes_cluster",
        "resourceName": tf_lib.get_resource_name(akscluster, name),
        "searchKey": sprintf("azurerm_kubernetes_cluster[%s].key_management_service.key_vault_network_access", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].key_management_service.key_vault_network_access should not be public", [name]),
        "keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].key_management_service.key_vault_network_access is set to public", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "key_management_service","key_vault_network_access"], []),
        "remediation": "Set key_vault_network_access to 'private' to restrict access to the Key Vault.",
        "remediationType": "update",
    }	
}
