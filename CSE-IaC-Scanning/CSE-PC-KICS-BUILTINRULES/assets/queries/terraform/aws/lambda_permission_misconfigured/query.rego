package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	
	resource := input.document[i].resource.aws_lambda_permission[name]
	resource.action != "lambda:InvokeFunction"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lambda_permission",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lambda_permission[%s].action", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_lambda_permission", name, "action"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_permission[%s].action should be 'lambda:InvokeFunction'", [name]),
		"keyActualValue": sprintf("aws_lambda_permission[%s].action is %s", [name, resource.action]),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.action]),
			"after": "lambda:InvokeFunction"
		}),
		"remediationType": "replacement",
	}
}
