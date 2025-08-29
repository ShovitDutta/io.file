package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	
	api_resource = input.document[i].resource.aws_api_gateway_method[name]

	api_resource.api_key_required == false
	api_resource.http_method != "OPTIONS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(api_resource, name),
		"searchKey": sprintf("resource.aws_api_gateway_method[%s].api_key_required", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method", name, "api_key_required"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required should be 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'false'", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
