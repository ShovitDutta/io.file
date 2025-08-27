package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].resource_labels
	not common_lib.valid_key(resource,"itpmid")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].resource_labels.itpmid", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_cluster[%s].resource_labels.itpmid should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_cluster[%s].resource_labels.itpmid is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "resource_labels"], []),
		"remediation": "update the itpmid under resource_labels",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].resource_labels
	not common_lib.valid_key(resource,"costcenter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].resource_labels.costcenter", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_cluster[%s].resource_labels.costcenter should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_cluster[%s].resource_labels.costcenter is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "resource_labels"], []),
		"remediation": "update the costcenter under resource_labels",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].resource_labels
	not common_lib.valid_key(resource,"dataclassification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].resource_labels.dataclassification", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_cluster[%s].resource_labels.dataclassification should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_cluster[%s].resource_labels.dataclassification is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "resource_labels"], []),
		"remediation": "update the dataclassification under resource_labels",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].resource_labels
	not common_lib.valid_key(resource,"environmenttype")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].resource_labels.environmenttype", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_cluster[%s].resource_labels.environmenttype should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_cluster[%s].resource_labels.environmenttype is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "resource_labels"], []),
		"remediation": "update the environmenttype under resource_labels",
		"remediationType": "addition",
	}	
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name].resource_labels
	not common_lib.valid_key(resource,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].resource_labels.sharedemailaddress", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_cluster[%s].resource_labels.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_cluster[%s].resource_labels.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "resource_labels"], []),
		"remediation": "update the sharedemailaddress under resource_labels",
		"remediationType": "addition",
	}	
}
