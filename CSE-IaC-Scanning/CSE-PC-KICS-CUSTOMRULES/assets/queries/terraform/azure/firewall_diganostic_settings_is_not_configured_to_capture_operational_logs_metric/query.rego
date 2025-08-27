package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	azureFirewall := input.document[i].resource.azurerm_firewall[name]
	resourcename = azureFirewall.name
	diagnosticresource := input.document[i].resource.azurerm_monitor_diagnostic_setting[dname]
	not contains(diagnosticresource.target_resource_id, resourcename)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(diagnosticresource, dname),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [dname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' should have the id of azure recovery service vault", [dname]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].target_resource_id' doesnot contain azure recovery service", [dname]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", dname], []),
		"remediation": "configure diagnostic settings for recovery service vault",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
		azureDiagnosticSettings := input.document[i].resource.azurerm_monitor_diagnostic_setting[name].enabled_log[k]
        azureDiagnosticSettings.category_group != "allLogs"

        result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(azureDiagnosticSettings, name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_monitor_diagnostic_setting[%s].enabled_log.category_group should have allLogs", [name]),
		"keyActualValue": sprintf("azurerm_monitor_diagnostic_setting[%s].enabled_log.category_group is not configured as allLogs", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "enabled_log"], []),
		"remediation": "configure log - category_group as allLogs",
		"remediationType": "update",
       }
}

CxPolicy[result] {
		azureDiagnosticSettings := input.document[i].resource.azurerm_monitor_diagnostic_setting[name].metric[k]
        azureDiagnosticSettings.category != "AllMetrics"

        result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(azureDiagnosticSettings, name),
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].metric.category", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_monitor_diagnostic_setting[%s].metric.category should have configured as AllMetrics", [name]),
		"keyActualValue": sprintf("azurerm_monitor_diagnostic_setting[%s].metric.category is not configured with AllMetrics", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "metric"], []),
		"remediation": "configure Diagnostic - metric category as AllMetrics",
		"remediationType": "update",
       }
}