package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib



CxPolicy[result] {
	az_data_bricks := input.document[i].resource.azurerm_databricks_workspace[name]
	not common_lib.valid_key(az_data_bricks,"custom_parameters")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].custom_parameters", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_databricks_workspace[%s].custom_parameters should be defined", [name]),
		"keyActualValue": sprintf("azurerm_databricks_workspace[%s].custom_parameters is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name], []),
		"remediation": "custom_parameters.no_public_ip = true should be added to the azurerm_databricks_workspace resource block.",
		"remediationType": "addition",
	}	
}


CxPolicy[result] {
	az_data_bricks := input.document[i].resource.azurerm_databricks_workspace[name].custom_parameters[k]
	
	az_data_bricks.no_public_ip == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(az_data_bricks, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s].custom_parameters.no_public_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters.no_public_ip' should be 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters.no_public_ip' is not 'true'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "custom_parameters","no_public_ip"], []),
		"remediation": "custom_parameters.no_public_ip = true should be added to the azurerm_databricks_workspace resource block.",
		"remediationType": "replacement",
	}
}

