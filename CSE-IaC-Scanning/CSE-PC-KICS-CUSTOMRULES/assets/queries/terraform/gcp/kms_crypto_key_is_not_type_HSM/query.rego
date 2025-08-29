package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cryptoKeyVersionTemplate := input.document[i].resource.google_kms_crypto_key[name].version_template[k]
	cryptoKeyVersionTemplate.protection_level != "HSM"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key",
		"resourceName": tf_lib.get_resource_name(cryptoKeyVersionTemplate, name),
		"searchKey": sprintf("google_kms_crypto_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_kms_crypto_key[%s].version_template.protection_level should be set to HSM", [name]),
		"keyActualValue": sprintf("google_kms_crypto_key[%s].version_template.protection_level is not set to HSM", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key", name, "version_template"], []),
		"remediation": "set the protection level to HSM",
		"remediationType": "update"
	}
}
