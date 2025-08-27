package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    cloudrun_job := input.document[i].resource.google_cloud_run_v2_job[name]
	cloudrun_job_template = cloudrun_job.template[j].template[k]
	not common_lib.valid_key(cloudrun_job_template, "service_account")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_job",
		"resourceName": tf_lib.get_resource_name(cloudrun_job, name),
		"searchKey": sprintf("google_cloud_run_v2_job[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_cloud_run_v2_job[%s].template.template.service_account should not be undefined", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_job[%s].template.template.service_account has default service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_job", name], []),
		"remediation": "specify service account details under cloudrun_job.template.template.service_account",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
    cloudrun_job := input.document[i].resource.google_cloud_run_v2_job[name]
	cloudrun_job_template_service_account = cloudrun_job.template[j].template[k].service_account
	contains(cloudrun_job_template_service_account, "developer")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_cloud_run_v2_job",
		"resourceName": tf_lib.get_resource_name(cloudrun_job, name),
		"searchKey": sprintf("google_cloud_run_v2_job[%s].template.template.service_account", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_cloud_run_v2_job[%s].template.template.service_account shouldn't have default SA", [name]),
		"keyActualValue": sprintf("google_cloud_run_v2_job[%s].template.template.service_account has default service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_cloud_run_v2_job", name, "template", "template", "template"], []),
		"remediation": "specify service account details under cloudrun_job.template.template.service_account",
		"remediationType": "update"
	}
}
