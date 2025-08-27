package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name].tags
	not common_lib.valid_key(azureFirewall,"itpmid")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].tags.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].tags.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].tags.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "tags"], []),
		"remediation": "update the itpmid under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name].tags
	not common_lib.valid_key(azureFirewall,"costcenter")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].tags.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].tags.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].tags.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "tags"], []),
		"remediation": "update the costcenter under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name].tags
	not common_lib.valid_key(azureFirewall,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].tags.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].tags.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].tags.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "tags"], []),
		"remediation": "update the dataclassification under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name].tags
	not common_lib.valid_key(azureFirewall,"environmenttype")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].tags.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].tags.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].tags.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "tags"], []),
		"remediation": "update the environmenttype under tag",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name].tags
	not common_lib.valid_key(azureFirewall,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].tags.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].tags.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].tags.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "tags"], []),
		"remediation": "update the sharedemailaddress under tag",
		"remediationType": "addition",
	}	
}