package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudwatch_log_group[%s].kms_key_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudwatch_log_group[%s].kms_key_id should be set", [name]),
		"keyActualValue": sprintf("aws_cloudwatch_log_group[%s].kms_key_id is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudwatch_log_group", name], []),
		"remediation": "CloudWatch log groups should be encrypted with a KMS key to ensure data security.",
		"remediationType": "manual",
	}
}
