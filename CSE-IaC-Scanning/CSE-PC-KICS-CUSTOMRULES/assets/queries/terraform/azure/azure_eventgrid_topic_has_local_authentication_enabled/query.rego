package Cx


import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

    az_event_grid_topic := input.document[i].resource.azurerm_eventgrid_topic[name]

    # Check if the resource has local authentication enabled
    az_event_grid_topic.local_auth_enabled == true

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_eventgrid_topic",
        "resourceName": tf_lib.get_resource_name(az_event_grid_topic, name),
        "searchKey": sprintf("azurerm_eventgrid_topic[%s].local_auth_enabled", [name]),
        "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_eventgrid_topic[%s].local_auth_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_eventgrid_topic[%s].local_auth_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_eventgrid_topic", name, "local_auth_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
    }
}