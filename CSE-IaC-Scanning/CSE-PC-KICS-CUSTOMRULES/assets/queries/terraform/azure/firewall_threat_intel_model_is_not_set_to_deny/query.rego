package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name]
	azureFirewall.threat_intel_mode != "Deny"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_firewall",
		"resourceName": tf_lib.get_resource_name(azureFirewall, name),
		"searchKey": sprintf("azurerm_firewall[%s].threat_intel_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_firewall[%s].threat_intel_mode should be defined and set to Deny", [name]),
		"keyActualValue": sprintf("azurerm_firewall[%s].threat_intel_mode is not set to Deny", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_firewall", name, "threat_intel_mode"], []),
		"remediation": "update the threat_intel_mode set to Deny",
		"remediationType": "update",
	}	
}
