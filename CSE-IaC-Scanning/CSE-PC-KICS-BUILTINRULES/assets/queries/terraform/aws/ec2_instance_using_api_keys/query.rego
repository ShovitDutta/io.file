package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


check_aws_api_keys(mdata) {
	count(regex.find_n(`aws_access_key_id\s*=|AWS_ACCESS_KEY_ID\s*=|aws_secret_access_key\s*=|AWS_SECRET_ACCESS_KEY\s*=`, mdata, -1)) > 0
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	check_aws_api_keys(resource.user_data)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].user_data", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
		"keyActualValue": sprintf("aws_instance[%s].user_data is being used to configure AWS API keys", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "user_data"], []),
		"remediation": "Use 'iam_instance_profile' to assign a role with permissions instead of using user_data for AWS API keys",
		"remediationType": "Manual",

	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	decoded := base64.decode(resource.user_data_base64)
	check_aws_api_keys(decoded)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].user_data_base64", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
		"keyActualValue": sprintf("aws_instance[%s].user_data_base64 is being used to configure AWS API keys", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "user_data_base64"], []),
		"remediation": "Use 'iam_instance_profile' to assign a role with permissions instead of using user_data for AWS API keys",
		"remediationType": "Manual",
	}
}