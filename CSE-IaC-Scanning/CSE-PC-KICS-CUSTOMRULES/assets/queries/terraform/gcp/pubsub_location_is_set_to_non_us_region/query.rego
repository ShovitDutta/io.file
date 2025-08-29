package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.every


CxPolicy[result] {
	resource := input.document[i].resource.google_pubsub_topic[name]
	not resource.message_storage_policy

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_pubsub_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_pubsub_topic[%s].message_storage_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_pubsub_topic[%s].message_storage_policy' should have allow persistence regions under message storage policy", [name]),
		"keyActualValue": sprintf("'google_pubsub_topic[%s].message_storage_policy' is missing allow persistence regions", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", name], []),
		"remediation": "add allowed_persistence_regions",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_pubsub_topic[nameps].message_storage_policy
	resourceallowedregion := resource.allowed_persistence_regions
	not inAllowedRegionStartswith(resourceallowedregion,"us-")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_pubsub_topic",
		"resourceName": tf_lib.get_resource_name(resource, nameps),
		"searchKey": sprintf("google_pubsub_topic[%s].message_storage_policy.allowed_persistence_regions", [nameps]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_pubsub_topic[%s].message_storage_policy.allowed_persistence_regions' should contain only US regions", [nameps]),
		"keyActualValue": sprintf("'google_pubsub_topic[%s].message_storage_policy.allowed_persistence_regions' is having non US region", [nameps]),
		"searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", nameps, "message_storage_policy", "allowed_persistence_regions"], []),
		"remediation": "update the allowed_persistence_regions set to have only US regions",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	message_storage_policy := input.document[i].resource.google_pubsub_topic[nameps].message_storage_policy[k]
	resourceallowedregion := message_storage_policy.allowed_persistence_regions
	not inAllowedRegionStartswith(resourceallowedregion,"us-")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_pubsub_topic",
		"resourceName": tf_lib.get_resource_name(message_storage_policy, nameps),
		"searchKey": sprintf("google_pubsub_topic[%s].message_storage_policy", [nameps]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_pubsub_topic.message_storage_policy.allowed_persistence_regions should contain only US regions", [nameps]),
		"keyActualValue": sprintf("google_pubsub_topic.message_storage_policy.allowed_persistence_regions is having non US region", [nameps]),
		"searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", nameps, "message_storage_policy", "allowed_persistence_regions"], []),
		"remediation": "update the allowed_persistence_regions set to have only US regions",
		"remediationType": "update",
	}
}


inAllowedRegionStartswith(mylist,allowedregion) {
	every list in mylist{
		startswith(list,allowedregion)
	}
}