package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Policy to check node_config defined
CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]
	not common_lib.valid_key(resource,"node_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_node_pool[%s].node_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google_container_node_pool[%s].node_config should be defined and not null",
		"keyActualValue": "google_container_node_pool[%s].node_config is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],[]),
		"remediation": "node_config should be defined",
		"remediationType": "addition",
	}
}

# Policy to check if node_config.image_type defined
CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]
	node_config := resource.node_config[k]
	not common_lib.valid_key(node_config, "image_type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_node_pool[%s].node_config.image_type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google_container_node_pool[%s].node_config.image_type should be defined and not null",
		"keyActualValue": "google_container_node_pool[%s].node_config.image_type is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["node_config"]),
		"remediation": "node_config.image_type should be defined",
		"remediationType": "addition",
	}
}

# Policy to check if node_config.image_type is set to COS

CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]
	node_config := resource.node_config[k]
	not startswith(lower(node_config.image_type), "cos")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_node_pool[%s].node_config.image_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'node_config.image_type' should start with 'COS'",
		"keyActualValue": "'node_config.image_type' does not start with 'COS'",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["node_config","image_type"]),
		"remediation": "node_config.image_type should be started with 'COS'",
		"remediationType": "addition"
	}
}
