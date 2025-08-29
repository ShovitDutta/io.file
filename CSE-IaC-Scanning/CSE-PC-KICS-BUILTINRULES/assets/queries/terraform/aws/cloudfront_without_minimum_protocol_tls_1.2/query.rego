package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]
	resource.enabled == true

	resource.viewer_certificate[n].cloudfront_default_certificate == true

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate' should be 'false'", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.cloudfront_default_certificate' is 'true'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "viewer_certificate", "cloudfront_default_certificate"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.aws_cloudfront_distribution[name]
	resource.enabled == true

	resource.viewer_certificate[n].cloudfront_default_certificate == false
	protocol_version := resource.viewer_certificate[n].minimum_protocol_version

	not common_lib.is_recommended_tls(protocol_version)

	result := {
		"documentId": document.id,
		"resourceType": "aws_cloudfront_distribution",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' should be TLSv1.2_x", [name]),
		"keyActualValue": sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version' is %s", [name, protocol_version]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudfront_distribution", name, "viewer_certificate", "minimum_protocol_version"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [protocol_version]),
			"after": "TLSv1.2_2021"
		}),
		"remediationType": "replacement",
	}
}