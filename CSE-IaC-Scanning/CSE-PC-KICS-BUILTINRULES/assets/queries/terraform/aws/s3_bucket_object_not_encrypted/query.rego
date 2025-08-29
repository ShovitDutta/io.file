package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	
	s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
	s3bucket_object := input.document[i].resource.aws_s3_bucket_object[name]

	# Validate if bucket has website configuration with varifying the bucket name attribute 'bucket'
	s3bucket_object.bucket == s3bucket.bucket	
	not common_lib.valid_key(s3bucket_object, "server_side_encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_object",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket_object, "aws_s3_bucket_object", name),
		"searchKey": sprintf("resource.aws_s3_bucket_object[%s]", [name]), 
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_s3_bucket_object[%s].server_side_encryption should be defined and not null", [name]),
		"keyActualValue": sprintf("resource.aws_s3_bucket_object[%s].server_side_encryption is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_object", name], []),
		"remediation": sprintf("Add the 'server_side_encryption' attribute to the 'aws_s3_bucket_object' resource '%s'.", [name]),
		"remediationType": "manual",
	}
}
