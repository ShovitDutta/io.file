package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	cloudfront := resource.aws_cloudfront_distribution[name]
	cloudfront.enabled == true
	loggingconfig := cloudfront.logging_config
	count(loggingconfig) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudfront_distribution[%s]", [name]),
		"issueType": "MissingAttribute",
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "logging_config"], []),
		"keyExpectedValue": sprintf("aws_cloudfront_distribution[%s].logging_config should be defined", [name]),
		"keyActualValue": sprintf("aws_cloudfront_distribution[%s].logging_config is undefined", [name]),
	}
}
