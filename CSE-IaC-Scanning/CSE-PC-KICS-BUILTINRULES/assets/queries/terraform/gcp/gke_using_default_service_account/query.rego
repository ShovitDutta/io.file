package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Policy to check if node_config is defined

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	not common_lib.valid_key(resource,"node_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google_container_cluster[%s].node_config should be defined and not null",
		"keyActualValue": "google_container_cluster[%s].node_config is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],[]),
		"remediation": "node_config should be defined",
		"remediationType": "addition",
	}
}

# Policy to check if service_account is defined
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	node_config := resource.node_config[k]
	not common_lib.valid_key(node_config, "service_account")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'service_account' should be defined and not null",
		"keyActualValue": "'service_account' not defined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["node_config"]),
	}
}

# Policy to check if service_account is default
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	node_config := resource.node_config[k]
	contains(lower(node_config.service_account), "compute@developer.gserviceaccount.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config.service_account", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' should not be default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["node_config", "service_account"]),
	}
}
