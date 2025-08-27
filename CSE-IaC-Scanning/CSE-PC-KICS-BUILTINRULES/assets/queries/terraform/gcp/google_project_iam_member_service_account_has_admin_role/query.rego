package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	projectIam := input.document[i].resource.google_project_iam_member[name]
	startswith(projectIam.member, "serviceAccount:")
	contains(projectIam.role, "roles/iam.serviceAccountAdmin")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_member",
		"resourceName": tf_lib.get_resource_name(projectIam, name),
		"searchKey": sprintf("google_project_iam_member[%s].role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_project_iam_member[%s].role should not be admin", [name]),
		"keyActualValue": sprintf("google_project_iam_member[%s].role is admin", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_project_iam_member", name, "role"],[]),
		"remediation": "google_project_iam_member should not have admin role assigned to service accounts.",
		"remediationType": "update",
	}
}


