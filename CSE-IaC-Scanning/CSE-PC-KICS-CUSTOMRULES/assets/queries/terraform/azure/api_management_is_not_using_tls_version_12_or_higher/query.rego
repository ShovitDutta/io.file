package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.security[k].enable_backend_tls11

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_api_management[name], name),
		"searchKey": sprintf("azurerm_api_management[%s].security.enable_backend_tls11", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_api_management.security.enable_backend_tls11 should be defined and set it to false",
		"keyActualValue": "azurerm_api_management.security.enable_backend_tls11 is set to true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "security"], []),
		"remediation": "set enable_backend_tls11 = false",
		"remediationType": "Update",
	}
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.security[k].enable_backend_tls10

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_api_management[name], name),
		"searchKey": sprintf("azurerm_api_management[%s].security.enable_backend_tls10", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_api_management.security.enable_backend_tls10 should be defined and set it to false",
		"keyActualValue": "azurerm_api_management.security.enable_backend_tls10 is set to true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "security"], []),
		"remediation": "set enable_backend_tls10 = false",
		"remediationType": "Update",
	}
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.security[k].enable_frontend_tls11

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_api_management[name], name),
		"searchKey": sprintf("azurerm_api_management[%s].security.enable_frontend_tls11", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_api_management.security.enable_frontend_tls11 should be defined and set it to false",
		"keyActualValue": "azurerm_api_management.security.enable_frontend_tls11 is set to true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "security"], []),
		"remediation": "set enable_frontend_tls11 = false",
		"remediationType": "Update",
	}
}

CxPolicy[result] {
	azureapimgmt := input.document[i].resource.azurerm_api_management[name]
	azureapimgmt.security[k].enable_frontend_tls10

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_api_management[name], name),
		"searchKey": sprintf("azurerm_api_management[%s].security.enable_frontend_tls10", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_api_management.security.enable_frontend_tls10 should be defined and set it to false",
		"keyActualValue": "azurerm_api_management.security.enable_frontend_tls10 is set to true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management", name, "security"], []),
		"remediation": "set enable_frontend_tls10 = false",
		"remediationType": "Update",
	}
}