package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	resource.default_cache_behavior[n].viewer_protocol_policy == "allow-all"


	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy should be 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
	resource.ordered_cache_behavior[n].viewer_protocol_policy == "allow-all"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy should be 'https-only' or 'redirect-to-https'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy isn't 'https-only' or 'redirect-to-https'", [name]),
	}
}
