package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Function to check if kind is either CustomVision.Training or CustomVision.Prediction
is_custom_vision(kind) {
	kind == "CustomVision.Training"
}

is_custom_vision(kind) {
	kind == "CustomVision.Prediction"
}


CxPolicy[result] {
	az_custom_vision := input.document[i].resource.azurerm_cognitive_account[name]
    is_custom_vision(az_custom_vision.kind)

	# Check if local_auth_enabled is set to true
	az_custom_vision.local_auth_enabled == true
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_cognitive_account",
		"resourceName": tf_lib.get_resource_name(az_custom_vision, name),
		"searchKey": sprintf("azurerm_cognitive_account[%s].local_auth_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_cognitive_account[%s].local_auth_enabled should be set to false", [name]),
		"keyActualValue": sprintf("azurerm_cognitive_account[%s].local_auth_enabled is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_cognitive_account", name, "local_auth_enabled"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement"
	}	
}

