package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].waf_configuration[k]
	azgateway.firewall_mode != "Prevention"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].waf_configuration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].waf_configuration.firewall_mode should be defined and set as Prevention", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].waf_configuration.firewall_mode is undefined or not set as Prevention", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "waf_configuration"], []),
		"remediation": json.marshal({
			"before": "Detective",
			"after": "Prevention"
		}),
		"remediationType": "replacement",
	}	
}

