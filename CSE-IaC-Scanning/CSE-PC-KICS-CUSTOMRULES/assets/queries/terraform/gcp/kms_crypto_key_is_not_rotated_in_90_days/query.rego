package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cryptoKey := input.document[i].resource.google_kms_crypto_key[name]
	cryptoKey.rotation_period != "7776000s"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(cryptoKey, name),
		"searchKey": sprintf("google_kms_crypto_key[%s].rotation_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_kms_crypto_key[%s].rotation_period should be set to 90 days", [name]),
		"keyActualValue": sprintf("google_kms_crypto_key[%s].rotation_period is not set to 90 days", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name, "rotation_period"], []),
		"remediation": "set rotation_period as 90days in sec",
		"remediationType": "update"
	}
}