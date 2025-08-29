package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings[j].ip_configuration[k]

	count(ip_configuration.authorized_networks) > 0

	authorized_network = getAuthorizedNetworks(ip_configuration.authorized_networks)

	contains(authorized_network[j].value, "0.0.0.0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.authorized_networks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'authorized_network' address should be trusted",
		"keyActualValue": "'authorized_network' address is not restricted: '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance", name],["settings","ip_configuration","authorized_networks","value"]),
		"remediation": "Restrict 'authorized_network' to trusted IP addresses or ranges. If public access is not required, disable 'ipv4_enabled' and set 'private_network' to a valid VPC network.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings[j].ip_configuration[k]

	count(ip_configuration.authorized_networks) == 0

	ip_configuration.ipv4_enabled  == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ipv4_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ipv4_enabled' should be disabled and 'private_network' should be defined when there are no authorized networks",
		"keyActualValue": "'ipv4_enabled' is enabled when there are no authorized networks",
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance", name],["settings", "ip_configuration", "ipv4_enabled"]),
		"remediation": "Disable 'ipv4_enabled' and set 'private_network' to a valid VPC network when there are no authorized networks.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	ip_configuration := resource.settings[j].ip_configuration[k]

	count(ip_configuration.authorized_networks) == 0

	ip_configuration.ipv4_enabled  == false

	common_lib.emptyOrNull(ip_configuration.private_network)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.private_network", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ipv4_enabled' should be disabled and 'private_network' should be defined when there are no authorized networks",
		"keyActualValue": "'private_network' is not defined when there are no authorized networks",
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance", name],["settings","ip_configuration","private_network"]),
		"remediation": "Disable 'ipv4_enabled' and set 'private_network' to a valid VPC network when there are no authorized networks.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_sql_database_instance[name]
	settings := resource.settings[j]

	not common_lib.valid_key(settings,"ip_configuration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ip_configuration' should be defined and allow only trusted networks",
		"keyActualValue": "'ip_configuration' is not defined",
		"searchLine": common_lib.build_search_line(["resource","google_sql_database_instance", name, "settings"],[]),
		"remediation": "Define 'ip_configuration' with 'authorized_networks' set to trusted networks or disable 'ipv4_enabled' and set 'private_network' to a valid VPC network.",
		"remediationType": "update",
	}
}

getAuthorizedNetworks(networks) = list {
    is_array(networks)
    list := networks
} else = list {
    is_object(networks)
    list := [networks]
} else = null

