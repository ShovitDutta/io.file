package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	tf_lib.allows_action_from_all_principals(resource.policy, "list")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Statement.Action' should not be a 'List' action when 'policy.Statement.Principal' contains '*'", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Statement.Action' is a 'List' action when 'policy.Statement.Principal' contains '*'", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
		"remeditation": "Ensure that the S3 bucket policy does not allow 'List' actions from all principals.",
		"remediationType": "Manual",
	}
}


