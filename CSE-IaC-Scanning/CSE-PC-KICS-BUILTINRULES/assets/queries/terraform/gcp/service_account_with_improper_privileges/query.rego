package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resources := {"google_project_iam_binding", "google_project_iam_member"}
	resource := input.document[i].resource[resources[idx]][name]

	tf_lib.check_member(resource, "serviceAccount:")
	has_improperly_privileges(resource.role)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].role", [resources[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].role should not have admin, editor, owner, or write privileges for service account member", [resources[idx], name]),
		"keyActualValue": sprintf("%s[%s].role has admin, editor, owner, or write privilege for service account member", [resources[idx], name]),
		"searchLine": common_lib.build_search_line(["resource", resources[idx], name, "role"], []),
	}
}

has_improperly_privileges(role) {
	privileges := {"admin", "owner", "editor"}
	contains(lower(role), privileges[x])
}
