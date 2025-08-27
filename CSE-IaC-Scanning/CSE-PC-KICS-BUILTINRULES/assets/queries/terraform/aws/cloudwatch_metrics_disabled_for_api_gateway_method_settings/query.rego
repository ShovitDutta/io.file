package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name]
	resource_settings :=  resource.settings[k]
	resource_settings.metrics_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name, "settings", "metrics_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled should be true", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name]
	resource_settings :=  resource.settings[k]
	not common_lib.valid_key(resource_settings, "metrics_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name, "settings"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is undefined or null", [name]),
		"remediation": "Define the metrics_enabled attribute in aws_api_gateway_method_settings settings block",
		"remediationType": "addition",
	}
}
