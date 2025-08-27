package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[name]
	types := {"aws_alb", "aws_lb"}
	name == types[x]
	res := resource[m]
	check_load_balancer_type(res, "load_balancer_type")
	res.drop_invalid_header_fields == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[x],
		"resourceName": tf_lib.get_resource_name(res, m),
		"searchKey": sprintf("%s[{{%s}}].drop_invalid_header_fields", [types[x], m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[{{%s}}].drop_invalid_header_fields should be set to true", [types[x], m]),
		"keyActualValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is set to false", [types[x], m]),
		"searchLine": common_lib.build_search_line(["resource", types[x], m, "drop_invalid_header_fields"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

check_load_balancer_type(res, lbt) {
	res[lbt] == "application"
} else {
	not common_lib.valid_key(res, lbt)
} else = false {
	true
}
