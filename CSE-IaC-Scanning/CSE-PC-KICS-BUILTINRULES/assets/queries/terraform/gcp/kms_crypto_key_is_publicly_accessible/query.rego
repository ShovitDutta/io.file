package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	kmsPolicy := input.document[i].resource.google_kms_crypto_key_iam_policy[name]

	policyData := kmsPolicy.policy_data

    # Parse the stringified JSON
    json.unmarshal(policyData, parsedPolicy)
	
	# Get bindings from the parsed policy
	bindings := parsedPolicy.bindings[_]

	# Check if any member in the bindings is publicly accessible
	contains(bindings.members[_], "allUsers")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key_iam_policy",
		"resourceName": tf_lib.get_resource_name(kmsPolicy, name),
		"searchKey": sprintf("google_kms_crypto_key_iam_policy[%s].policy_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "KMS crypto key should not be publicly accessible",
		"keyActualValue": "KMS crypto key is publicly accessible",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_iam_policy", name, "policy_data"], []),
		"remediation": "Remove the 'allUsers' member from the IAM policy bindings for the KMS crypto key.",
		"remediationType": "update",
	}
}

CxPolicy[result] {
	kmsPolicy := input.document[i].resource.google_kms_crypto_key_iam_policy[name]

	policyData := kmsPolicy.policy_data

    # Parse the stringified JSON
    json.unmarshal(policyData, parsedPolicy)
	
	# Get bindings from the parsed policy
	bindings := parsedPolicy.bindings[_]
	
	# Check if any member in the bindings is publicly accessible
	contains(bindings.members[_], "allAuthenticatedUsers")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_kms_crypto_key_iam_policy",
		"resourceName": tf_lib.get_resource_name(kmsPolicy, name),
		"searchKey": sprintf("google_kms_crypto_key_iam_policy[%s].policy_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "KMS crypto key should not be publicly accessible",
		"keyActualValue": "KMS crypto key is publicly accessible",
		"searchLine": common_lib.build_search_line(["resource", "google_kms_crypto_key_iam_policy", name, "policy_data"], []),
		"remediation": "Remove the 'allAuthenticatedUsers' member from the IAM policy bindings for the KMS crypto key.",
		"remediationType": "update",
	}
}