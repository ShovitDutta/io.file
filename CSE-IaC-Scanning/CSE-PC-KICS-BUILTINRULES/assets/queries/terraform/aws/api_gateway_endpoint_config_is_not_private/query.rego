package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	api_gateway_apiresource := input.document[i].resource.aws_api_gateway_rest_api[name]

	endpoint_configuration := api_gateway_apiresource.endpoint_configuration[k]

	upper(endpoint_configuration.types[index]) != "PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(api_gateway_apiresource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].endpoint_configuration.types", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_rest_api", name,"endpoint_configuration", "types"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_rest_api[%s].endpoint_configuration.types' should be 'PRIVATE'", [name]),
		"keyActualValue": sprintf("aws_api_gateway_rest_api[%s].endpoint_configuration.types is not 'PRIVATE'", [name]),
		"remediation": json.marshal({
			"before": sprintf("%s",[endpoint_configuration.types[index]]),
			"after": "PRIVATE"
		}),
		"remediationType": "replacement",
	}
}
