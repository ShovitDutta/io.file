package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource_subnet := input.document[i].resource.azure_virtual_network[name].subnet[k]
	not common_lib.valid_key(resource_subnet,"security_group")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azure_virtual_network",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azure_virtual_network[name], name),
		"searchKey": sprintf("azure_virtual_network[%s].subnet.security_group", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azure_virtual_network[%s].subnet' should contain security_group", [name]),
		"keyActualValue": sprintf("'azure_virtual_network[%s].subnet' is missing security_group", [name]),
	}
}
