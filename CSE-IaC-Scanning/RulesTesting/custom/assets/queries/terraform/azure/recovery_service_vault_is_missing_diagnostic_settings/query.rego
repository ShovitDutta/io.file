package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]
	resourcename = resource.name
	diagnosticresource := input.document[i].resource.azurerm_monitor_diagnostic_setting[dname]
	target_resource_id_lower = lower(diagnosticresource.target_resource_id)
	   
	not contains(target_resource_id_lower, resourcename)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnosticresource, dname),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].target_resource_id", [dname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' should have the id of azure recovery service vault", [dname]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' doesnot contain azure recovery service", [dname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", dname], []),
		"remediation": "configure diagnostic settings for recovery service vault",
		"remediationType": "addition",
	}
}