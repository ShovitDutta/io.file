package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name]
	resourcename = resource.name
	diagnosticresource := input.document[i].resource.azurerm_monitor_diagnostic_setting[dname]
	not contains(diagnosticresource.target_resource_id, resourcename)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnosticresource, dname),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [dname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' should have the id of azure traffic manager", [dname]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' doesnot contain azure traffic manager", [dname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", dname], []),
		"remediation": "configure diagnostic settings for azure traffic manager",
		"remediationType": "addition",
	}
}