package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the azurerm_databricks_workspace resource has public_network_access_enabled set to false.

CxPolicy[result] {
	az_data_bricks := input.document[i].resource.azurerm_databricks_workspace[name]

	# Check if public_network_access_enabled is set to true
	az_data_bricks.public_network_access_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].public_network_access_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].public_network_access_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].public_network_access_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "public_network_access_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}