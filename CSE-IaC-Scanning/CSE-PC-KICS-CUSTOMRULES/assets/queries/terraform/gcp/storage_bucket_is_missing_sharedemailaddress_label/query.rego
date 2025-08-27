package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	storageBucket := input.document[i].resource.google_storage_bucket[name]
	not common_lib.valid_key(storageBucket.labels,"sharedemailaddress")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_storage_bucket",
		"resourceName": tf_lib.get_resource_name(storageBucket, name),
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_storage_bucket[%s].labels.sharedemailaddress should be defined and not null", [name]),
		"keyActualValue": sprintf("google_storage_bucket[%s].labels.sharedemailaddress is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_storage_bucket", name], []),
		"remediation": "sharedemailaddress = some_address",
		"remediationType": "addition",
	}
}
