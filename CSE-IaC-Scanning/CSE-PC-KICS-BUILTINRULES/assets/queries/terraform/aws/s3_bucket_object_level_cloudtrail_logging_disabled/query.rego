package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]

	# check if cloud trail configuration exists for s3 bucket
	cloudtrail.s3_bucket_name == s3bucket.bucket

	# get the event selector for the cloudtrail
	cloud_trail_event_selector := cloudtrail.event_selector[k]

	cloud_trail_event_selector.data_resource[l].type == "AWS::S3::Object"
	cloud_trail_event_selector.read_write_type != "All"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_specific_resource_name(cloudtrail, "aws_cloudtrail", name),
		"searchKey": sprintf("aws_cloudtrail[%s].event_selector.read_write_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].event_selector.read_write_type should be set to 'All'", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].event_selector.read_write_type is not set to 'All'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudtrail", name, "event_selector", "read_write_type"], []),
		"remediation": sprintf("Set the 'read_write_type' to 'All' in the 'aws_cloudtrail' resource '%s'.", [name]),
		"remediationType": "manual",
	}
}
