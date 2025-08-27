package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].waf_configuration
	count(azgateway) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].waf_configuration", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].waf_configuration should be defined", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].waf_configuration is undefined or empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "waf_configuration"], []),
		"remediation": "define waf_configuration and set enabled to true",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].waf_configuration[k]
	azgateway.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].waf_configuration", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].waf_configuration.enabled should be set to true", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].waf_configuration.enabled is not set enabled to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "waf_configuration", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}	
}

