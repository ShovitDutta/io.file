package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the management.auto_repair attribute is set to false.
CxPolicy[result] {
	management := input.document[i].resource.google_container_node_pool[name].management[k]
	management.auto_repair == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_node_pool[name], name),
		"searchKey": sprintf("google_container_node_pool[%s].management.auto_repair", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "management.auto_repair should be true",
		"keyActualValue": "management.auto_repair is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["management", "auto_repair"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
