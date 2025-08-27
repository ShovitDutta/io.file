package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resource_type := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	res_type := resource_type[_]
	resource := input.document[i].resource[res_type][name]

	all_permissions(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"resourceType": res_type,
		"resourceName": tf_lib.get_specific_resource_name(resource, res_type, name),
		"searchKey": sprintf("%s[%s].policy", [res_type,name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Statement' should not allow all actions to all principal", [res_type,name]),
		"keyActualValue": sprintf("%s[%s].policy.Statement' allows all actions to all principal", [res_type,name]),
		"searchLine": common_lib.build_search_line(["resource", res_type, name, "policy"], []),
		"remediation": "Remove the wildcard (*) from Action and Principal in the policy statement or restrict the permissions as much as possible.",
		"remediationType": "update",
	}
}



all_permissions(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.containsOrInArrayContains(statement.Action, "*")
	common_lib.containsOrInArrayContains(statement.Principal, "*")
}
