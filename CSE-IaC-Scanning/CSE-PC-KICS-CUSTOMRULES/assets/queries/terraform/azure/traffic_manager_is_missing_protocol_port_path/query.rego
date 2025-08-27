package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name].monitor_config[j]
	not common_lib.valid_key(resource, "protocol")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_traffic_manager_profile[name], name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].monitor_config.protocol", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.protocol' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.protocol' is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "monitor_config"], []),
		"remediation": "define the protocol inside monitor_config",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name].monitor_config[j]
	not common_lib.valid_key(resource, "port")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_traffic_manager_profile[name], name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].monitor_config.port", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.port' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.port' is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "monitor_config"], []),
		"remediation": "define the port inside monitor_config",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_traffic_manager_profile[name].monitor_config[j]
	not common_lib.valid_key(resource, "path")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_traffic_manager_profile",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_traffic_manager_profile[name], name),
		"searchKey": sprintf("azurerm_traffic_manager_profile[%s].monitor_config.port", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.path' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_traffic_manager_profile[%s].monitor_config.path' is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_traffic_manager_profile", name, "monitor_config"], []),
		"remediation": "define the path inside monitor_config",
		"remediationType": "addition",
	}
}