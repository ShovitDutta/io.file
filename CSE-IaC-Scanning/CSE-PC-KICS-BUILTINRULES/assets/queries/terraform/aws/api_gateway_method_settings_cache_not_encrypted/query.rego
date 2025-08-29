package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name]
	resource_settings := resource.settings[k]

	resource_settings.caching_enabled == true
	resource_settings.cache_data_encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings.cache_data_encrypted", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name, "settings", "cache_data_encrypted"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.cache_data_encrypted should be set to true", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.cache_data_encrypted is set to false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name]
	resource_settings := resource.settings[k]

	resource_settings.caching_enabled == true
	not common_lib.valid_key(resource_settings, "cache_data_encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name, "settings" ], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.cache_data_encrypted should be set to true", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.cache_data_encrypted is missing", [name]),
		"remediation": "cache_data_encrypted = true",
		"remediationType": "addition",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name]
	resource_settings := resource.settings[k]

	both_cache_settings_missing(resource_settings)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name,"settings" ], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings should have caching_enabled & cache_data_encrypted defined and cache_data_encrypted set to be true", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings is missing caching_enabled & cache_data_encrypted", [name]),
		"remediation": "caching_enabled = true\ncache_data_encrypted = true",
		"remediationType": "addition",
	}

}

# Helper function to check if both cache settings are missing
both_cache_settings_missing(settings) {
	not common_lib.valid_key(settings, "caching_enabled")
	not common_lib.valid_key(settings, "cache_data_encrypted")
}
