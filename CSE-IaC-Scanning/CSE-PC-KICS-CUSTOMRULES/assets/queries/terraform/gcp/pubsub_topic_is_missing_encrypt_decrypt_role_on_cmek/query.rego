package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pubsub := input.document[i].resource.google_pubsub_topic[name]
	contains(pubsub.kms_key_name, "google_kms_crypto_key")
	cryptokeyiam = input.document[i].resource.google_kms_crypto_key_iam_member[pname]
	not contains(cryptokeyiam.role, "roles/cloudkms.cryptoKeyEncrypterDecrypter")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key_iam_member",
		"resourceName": tf_lib.get_resource_name(cryptokeyiam, pname),
		"searchKey": sprintf("google_kms_crypto_key_iam_member[%s].role", [pname]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_kms_crypto_key_iam_member[%s].role' should have the cryptoKeyEncrypterDecrypter role assigned", [pname]),
		"keyActualValue": sprintf("'google_kms_crypto_key_iam_member[%s].role' has non encryptordecryptor role or null", [pname]),
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_iam_member", pname, "role"], []),
		"remediation": "assign cryptoKeyEncrypterDecrypter role",
		"remediationType": "update",
	}
}	