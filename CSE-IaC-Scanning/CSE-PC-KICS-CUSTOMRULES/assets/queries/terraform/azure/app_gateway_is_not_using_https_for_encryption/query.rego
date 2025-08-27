package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].http_listener[k]
	azgateway.protocol != "Https"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].http_listener.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].http_listener.protocol should be defined and set it to Https", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].http_listener.protocol is not set to Https", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "http_listener"], []),
		"remediation": "http_listener.protocol should be set it to Https",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].backend_http_settings[k]
	azgateway.protocol != "Https"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].backend_http_settings.protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].backend_http_settings.protocol should be defined and set it to Https", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].backend_http_settings.protocol is not set to Https", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "backend_http_settings"], []),
		"remediation": "backend_http_settings.protocol should be set it to Https",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].backend_http_settings[k]
	azgateway.port != 443

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].backend_http_settings.port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].backend_http_settings.port should be defined and set it to 443", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].backend_http_settings.port is not set to 443", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "backend_http_settings"], []),
		"remediation": "backend_http_settings.port should be set it to 443",
		"remediationType": "update",
	}	
}

CxPolicy[result] {
	azgateway := input.document[i].resource.azurerm_application_gateway[name].frontend_port[k]
	azgateway.port != 443

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_application_gateway",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_application_gateway[name], name),
		"searchKey": sprintf("azurerm_application_gateway[%s].frontend_port.port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_application_gateway[%s].frontend_port.port should be defined and set it to 443", [name]),
		"keyActualValue": sprintf("azurerm_application_gateway[%s].frontend_port.port is not set to 443", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_application_gateway", name, "frontend_port"], []),
		"remediation": "frontend_port.port should be set it to 443",
		"remediationType": "update",
	}	
}
