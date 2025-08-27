package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    cloudrun_svc := input.document[i].resource.google_cloud_run_v2_service[name]
	cloudrun_svc_template = cloudrun_svc.template[j]
	not common_lib.valid_key(cloudrun_svc_template, "service_account")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_service",
		"resourceName": tf_lib.get_resource_name(cloudrun_svc, name),
		"searchKey": sprintf("google_cloud_run_v2_service[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_cloud_run_v2_service[%s].template.service_account should not be undefined", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_service[%s].template.service_account has default service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_service", name], []),
		"remediation": "specify service account details under cloudrun_svc.template.service_account",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
    cloudrun_svc := input.document[i].resource.google_cloud_run_v2_service[name]
	cloudrun_svc_template_service_account = cloudrun_svc.template[j].service_account
	contains(cloudrun_svc_template_service_account, "developer")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_service",
		"resourceName": tf_lib.get_resource_name(cloudrun_svc, name),
		"searchKey": sprintf("google_cloud_run_v2_service[%s].template.service_account", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_cloud_run_v2_service[%s].template.service_account shouldn't have default SA", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_service[%s].template.service_account has default service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_service", name, "template", "service_account"], []),
		"remediation": "specify correct service account details under cloudrun_svc.service_account",
		"remediationType": "update"
	}
}
