package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Policy to check private_cluster_config is defined and not null
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	private_cluster_config := resource.private_cluster_config
	count(private_cluster_config) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].private_cluster_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'google_container_cluster[%s].private_cluster_config' should be defined and not null",
		"keyActualValue": "Attribute 'google_container_cluster[%s].private_cluster_config' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["private_cluster_config"]),
	}
}

# Policy to check private_cluster_config.enable_private_endpoint & private_cluster_config.enable_private_nodes is defined & set true
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	private_cluster_config := resource.private_cluster_config[k]
	count(private_cluster_config) > 0
	is_not_true(private_cluster_config.enable_private_endpoint)
	is_not_true(private_cluster_config.enable_private_nodes)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].private_cluster_config.enable_private_nodes", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'google_container_cluster[%s].private_cluster_config.enable_private_endpoint' should be true and Attribute 'google_container_cluster[%s].private_cluster_config.enable_private_nodes' should be true",
		"keyActualValue": "Attribute 'google_container_cluster[%s].private_cluster_config.enable_private_endpoint' is false or Attribute 'google_container_cluster[%s].private_cluster_config.enable_private_nodes' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["private_cluster_config","enable_private_nodes"]),
	}
}

is_not_true(val) = true {
	val != true
}
