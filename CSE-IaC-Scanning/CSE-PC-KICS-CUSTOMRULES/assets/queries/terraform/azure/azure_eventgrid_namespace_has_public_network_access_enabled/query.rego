package Cx


import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

    az_event_grid_namespace := input.document[i].resource.azurerm_eventgrid_namespace[name]

    # Check if the resource has public_network_access enabled
    upper(az_event_grid_namespace.public_network_access) == "ENABLED"

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_eventgrid_namespace",
        "resourceName": tf_lib.get_resource_name(az_event_grid_namespace, name),
        "searchKey": sprintf("azurerm_eventgrid_namespace[%s].public_network_access", [name]),
        "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_eventgrid_namespace[%s].public_network_access should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_eventgrid_namespace[%s].public_network_access is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_eventgrid_namespace", name, "public_network_access"], []),
		"remediation": json.marshal({
			"before": "Enabled",
			"after": "Disabled"
		}),
		"remediationType": "replacement"
    }
}