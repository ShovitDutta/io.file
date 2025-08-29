package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cloudrun_svc := input.document[i].resource.google_cloud_run_v2_service[name]
	cloudrun_svc_template = cloudrun_svc.template[j]
	not common_lib.valid_key(cloudrun_svc_template, "encryption_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_service",
		"resourceName": tf_lib.get_resource_name(cloudrun_svc, name),
		"searchKey": sprintf("google_cloud_run_v2_service[%s]", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("google_cloud_run_v2_service[%s].template.encryption_key should be there", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_service[%s].template.encryption_key is missing", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_service", name], []),
		"remediation": "add CMEK under cloudrun_svc.encryption_key",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
	cloudrun_svc := input.document[i].resource.google_cloud_run_v2_service[name]
	cloudrun_svc_template_encrypt_key = cloudrun_svc.template[j].encryption_key
	not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",cloudrun_svc_template_encrypt_key)
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_service",
		"resourceName": tf_lib.get_resource_name(cloudrun_svc, name),
		"searchKey": sprintf("google_cloud_run_v2_service[%s].template.encryption_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_cloud_run_v2_service[%s].template.encryption_key should be configured with valid CMEK", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_service[%s].template.encryption_key is using an invalid CMEK", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_service", name,"template","encryption_key"], []),
		"remediation": "Update the correct CMEK value under encryption_key",
		"remediationType": "update"
	}
}