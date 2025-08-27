package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pubsub := input.document[i].resource.google_pubsub_topic[name]
	not pubsub.kms_key_name

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_pubsub_topic",
		"resourceName": tf_lib.get_resource_name(pubsub, name),
		"searchKey": sprintf("google_pubsub_topic[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_pubsub_topic[%s].kms_key_name' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_pubsub_topic[%s].kms_key_name' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_pubsub_topic", name], []),
		"remediation": "add kms_key_name under google_pubsub_topic",
		"remediationType": "addition"
	}
}	