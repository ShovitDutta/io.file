package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name].tags
	not common_lib.valid_key(akscluster,"itpmid")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name].tags
	not common_lib.valid_key(akscluster,"costcenter")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name].tags
	not common_lib.valid_key(akscluster,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name].tags
	not common_lib.valid_key(akscluster,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	akscluster := input.document[i].resource.azurerm_kubernetes_cluster[name].tags
	not common_lib.valid_key(akscluster,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_kubernetes_cluster",
		"resourceName": tf_lib.get_resource_name(akscluster, name),
		"searchKey": sprintf("azurerm_kubernetes_cluster[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_kubernetes_cluster[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_kubernetes_cluster[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_kubernetes_cluster", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}