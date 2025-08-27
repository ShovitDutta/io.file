package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	not resource.ip_allocation_policy
	not resource.networking_mode

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].networking_mode", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attributes 'ip_allocation_policy' and 'networking_mode' should be defined",
		"keyActualValue": "Attributes 'ip_allocation_policy' and 'networking_mode' are undefined",
		"searchLine": common_lib.build_search_line(["resource","google_container_cluster", name],[]),
		"remediation": "Define 'ip_allocation_policy' and 'networking_mode' attributes in the 'google_container_cluster' resource to ensure proper IP aliasing configuration.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	not resource.ip_allocation_policy
	upper(resource.networking_mode) == "VPC_NATIVE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].ip_allocation_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'ip_allocation_policy' should be defined",
		"keyActualValue": "Attribute 'ip_allocation_policy' is undefined",
		"searchLine": common_lib.build_search_line(["resource","google_container_cluster", name],[]),
		"remediation": "Define 'ip_allocation_policy' attribute in the 'google_container_cluster' resource to ensure proper IP aliasing configuration.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	resource.ip_allocation_policy
	upper(resource.networking_mode) == "ROUTES"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].networking_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'networking_mode' should be VPC_NATIVE",
		"keyActualValue": "Attribute 'networking_mode' is ROUTES",
		"searchLine": common_lib.build_search_line(["resource","google_container_cluster", name],["networking_mode"]),
		"remediation": "Change 'networking_mode' attribute to 'VPC_NATIVE' in the 'google_container_cluster' resource to ensure proper IP aliasing configuration.",
		"remediationType": "update",
	}
}
