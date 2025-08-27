package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# version before TF AWS 4.0
CxPolicy[result] {
	
	resource := input.document[i].resource.aws_s3_bucket[name]
	resource.acl == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].acl should be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].acl is authenticated-read", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
		"remediation": sprintf("Change the value of aws_s3_bucket[%s].acl to 'private'", [name]),
		"remediationType": "manual",

	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	
	s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
	bucket_acl := input.document[i].resource.aws_s3_bucket_acl[name]
	bucket_acl.bucket == s3bucket.bucket
	
	bucket_acl.acl == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_resource_name(bucket_acl, name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s].acl should be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s].acl is authenticated-read", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
		"remediation": sprintf("Change the value of aws_s3_bucket_acl[%s].acl to 'private'", [name]),
		"remediationType": "manual",
	}
}
