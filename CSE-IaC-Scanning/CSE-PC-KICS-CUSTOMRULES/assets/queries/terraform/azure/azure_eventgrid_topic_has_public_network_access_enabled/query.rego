package Cx


import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

    az_event_grid_topic := input.document[i].resource.azurerm_eventgrid_topic[name]

    # Check if the resource has public_network_access enabled
    az_event_grid_topic.public_network_access_enabled == true

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_eventgrid_topic",
        "resourceName": tf_lib.get_resource_name(az_event_grid_topic, name),
        "searchKey": sprintf("azurerm_eventgrid_topic[%s].public_network_access_enabled", [name]),
        "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_eventgrid_topic[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_eventgrid_topic[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_eventgrid_topic", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
    }
}