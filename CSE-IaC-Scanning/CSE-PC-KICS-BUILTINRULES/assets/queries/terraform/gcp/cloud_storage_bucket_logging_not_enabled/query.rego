package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]
	count(resource.logging) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_storage_bucket[%s].logging", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_storage_bucket[%s].logging' should be set",
		"keyActualValue": "'google_storage_bucket[%s].logging' is undefined",
		"searchLine": common_lib.build_search_line(["resource","google_storage_bucket", name, "logging"],[]),
		"remediation": "Set 'google_storage_bucket[%s].logging' to enable logging for the storage bucket.",
		"remediationType": "update",
	}
}
