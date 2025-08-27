package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFirewallPolicy := input.document[i].resource.azurerm_firewall_policy[name].intrusion_detection[k]
	not common_lib.valid_key(azureFirewallPolicy,"mode")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall_policy",
		"resourceName": tf_lib.get_resource_name(azureFirewallPolicy, name),
		"searchKey": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_policy", name, "intrusion_detection"], []),
		"remediation": "update the mode under intrusion_detection",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azureFirewallPolicy := input.document[i].resource.azurerm_firewall_policy[name].intrusion_detection[k]
	azureFirewallPolicy.mode != "Deny"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall_policy",
		"resourceName": tf_lib.get_resource_name(azureFirewallPolicy, name),
		"searchKey": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode should be defined and set to Deny", [name]),
		"keyActualValue": sprintf("azurerm_firewall_policy[%s].intrusion_detection.mode is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall_policy", name, "intrusion_detection"], []),
		"remediation": "update the mode and set to Deny",
		"remediationType": "update",
	}	
}

