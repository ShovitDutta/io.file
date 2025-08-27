package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib



CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_binding[name]
	inArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountTokenCreator")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_binding",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_binding[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_binding[%s].role should not be Service Account Token Creator", [name]),
		"keyActualValue": sprintf("google_project_iam_binding[%s].role is Service Account Token Creator", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_iam_binding", name, "role"],[]),
		"remediation": "google_project_iam_binding should not have Service Account Token Creator role assigned to service accounts.",
		"remediationType": "update",
	}
}



CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_binding[name]
	inArray(projectIam.members, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountUser")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_binding",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_binding[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_binding[%s].role should not be Service Account User", [name]),
		"keyActualValue": sprintf("google_project_iam_binding[%s].role is Service Account User", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_iam_binding", name, "role"],[]),
		"remediation": "google_project_iam_binding should not have Service Account User role assigned to service accounts.",
		"remediationType": "update",
	}
}

inArray(array, elem) {
	startswith(array[_], elem)
}
