package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cryptoKeyVersion := input.document[i].resource.google_kms_crypto_key_version[name]
	not common_lib.valid_key(cryptoKeyVersion, "state")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key_version",
		"resourceName": tf_lib.get_resource_name(cryptoKeyVersion, name),
		"searchKey": sprintf("google_kms_crypto_key_version[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_kms_crypto_key_version[%s].state should be defined and not null", [name]),
		"keyActualValue": sprintf("google_kms_crypto_key_version[%s].state is not defined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_version", name], []),
		"remediation": "define state",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
	cryptoKeyVersion := input.document[i].resource.google_kms_crypto_key_version[name]
	cryptoKeyVersion.state != "ENABLED"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key_version",
		"resourceName": tf_lib.get_resource_name(cryptoKeyVersion, name),
		"searchKey": sprintf("google_kms_crypto_key_version[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_kms_crypto_key_version[%s].state should be ENABLED", [name]),
		"keyActualValue": sprintf("google_kms_crypto_key_version[%s].state is not ENABLED", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_version", name, "state"], []),
		"remediation": "set state as ENABLED",
		"remediationType": "addition"
	}
}