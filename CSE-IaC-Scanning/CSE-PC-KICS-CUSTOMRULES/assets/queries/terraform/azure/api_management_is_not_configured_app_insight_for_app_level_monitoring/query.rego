package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureapimgmtlogger := input.document[i].resource.azurerm_api_management_logger[name].application_insights
	count(azureapimgmtlogger) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_api_management_logger",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_api_management_logger[name], name),
		"searchKey": sprintf("azurerm_api_management_logger[%s].application_insights", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_api_management_logger[%s].application_insights should be defined", [name]),
		"keyActualValue": sprintf("azurerm_api_management_logger[%s].application_insights is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_api_management_logger", name], []),
		"remediation": "define the application_insights",
		"remediationType": "addition",
	}
}