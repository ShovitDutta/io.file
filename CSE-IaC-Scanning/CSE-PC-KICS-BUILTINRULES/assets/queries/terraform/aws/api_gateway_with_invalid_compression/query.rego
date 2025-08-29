package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	not commonLib.valid_key(resource, "minimum_compression_size")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s]", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_api_gateway_rest_api", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size should be set and have a value between 0 and 10485760 (inclusive)", [name]),
		"keyActualValue": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size is undefined", [name]),
		"remediation": "minimum_compression_size = 0",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	size := to_number(resource.minimum_compression_size)
	any([size < 0, size > 10485760])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_api_gateway_rest_api", name, "minimum_compression_size"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size should be between 0 and 10485760 (inclusive)", [name]),
		"keyActualValue": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size is having invalid value", [name]),
		"remediation": json.marshal({
			"before": sprintf("%d", [size]),
			"after": "0"
		}),
		"remediationType": "replacement",
	}
}
