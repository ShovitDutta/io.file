package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# Policy to check if network policy and addons_config is not defined.
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	network_policy := resource.network_policy
	count(network_policy) == 0
	not common_lib.valid_key(resource,"addons_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].network_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'network_policy' should be defined and Attribute 'addons_config' should be defined for google_container_cluster[%s]", [name]),
		"keyActualValue": sprintf("Attribute 'network_policy' is undefined or Attribute 'addons_config' is undefined for google_container_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],["network_policy"]),
		"remediation": "network_policy and addons_config should be defined",
		"remediationType": "addition",
	}
}

# Policy to check if network policy not defined 

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	network_policy := resource.network_policy
	count(network_policy) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].network_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'network_policy' should be defined for google_container_cluster[%s]", [name]),
		"keyActualValue": sprintf("Attribute 'network_policy' is undefined for google_container_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],["network_policy"]),
		"remediation": "network_policy should be defined",
		"remediationType": "addition",
	}
}

# Policy to check if addons_config not defined

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	not common_lib.valid_key(resource,"addons_config")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'addons_config' should be defined for google_container_cluster[%s]", [name]),
		"keyActualValue": sprintf("Attribute 'addons_config' is undefined for google_container_cluster[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],[]),
		"remediation": "addons_config should be defined",
		"remediationType": "addition",
	}
}


# Policy to check if network policy enabled is false
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	# Check Addons_config.network_policy_config.disabled is false
	addons_config_network_policy := resource.addons_config[m].network_policy_config[n]
	addons_config_network_policy.disabled == false
	# Check if network_policy
	network_policy := resource.network_policy[k]
	network_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].network_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'network_policy.enabled' should be set to true",
		"keyActualValue": "Attribute 'network_policy.enabled' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],["network_policy", "enabled"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


# Policy to check if addons_config.network_policy_config.disabled is true
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	# Check if network_policy
	network_policy := resource.network_policy[k]
	network_policy.enabled == true
	# Check Addons_config.network_policy_config.disabled is false
	addons_config_network_policy := resource.addons_config[m].network_policy_config[n]
	addons_config_network_policy.disabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].addons_config.network_policy_config.disabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute '.addons_config.network_policy_config.disabled' should be set to false",
		"keyActualValue": "Attribute '.addons_config.network_policy_config.disabled' is true",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],["addons_config", "network_policy_config","disabled"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

# Policy to check if network policy enabled is false and addons_config.network_policy_config.disabled is true
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	# Check if network_policy
	network_policy := resource.network_policy[k]
	network_policy.enabled == false
	# Check Addons_config.network_policy_config.disabled is false
	addons_config_network_policy := resource.addons_config[m].network_policy_config[n]
	addons_config_network_policy.disabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].network_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'network_policy.enabled' should be set to true and Attribute 'addons_config.network_policy_config.disabled' should be set to false",
		"keyActualValue": "Attribute 'network_policy.enabled' should be set to false and Attribute 'addons_config.network_policy_config.disabled' should be set to true",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name],["network_policy", "enabled"]),
		"remediation": "Attribute 'network_policy.enabled' should be set to true and Attribute 'addons_config.network_policy_config.disabled' should be set to false",
		"remediationType": "addition",		
	}
}