package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# version before TF AWS 4.0
CxPolicy[result] {

	resource := input.document[i].resource.aws_s3_bucket[name]
	count(resource.website) > 0
	# Get S3 bucket name
	bucket_name := resource.bucket
	s3bucketname := tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("resource.aws_s3_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].website should not have static websites inside", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].website does have static websites inside", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "website"], []),
		"remediation": sprintf("Remove the 'website' block from the 'aws_s3_bucket' resource '%s'.", [name]),
		"remediationType": "manual",
	}
}

# version after TF AWS 4.0
CxPolicy[result] {	
	s3bucket := input.document[i].resource.aws_s3_bucket[name]
	s3bucket_webconf := input.document[i].resource.aws_s3_bucket_website_configuration[bucketName]

	# Validate if bucket has website configuration with varifying the bucket name attribute 'bucket'
	s3bucket_webconf.bucket == s3bucket.bucket	

	s3bucketname := tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", name),
		"searchKey": sprintf("resource.aws_s3_bucket[%s]", [name]),
		"issueType": "IncorrectAssociation",
		"keyExpectedValue":  sprintf("aws_s3_bucket[%s] should not have 'aws_s3_bucket_website_configuration' associated", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s]  has 'aws_s3_bucket_website_configuration' associated", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
		"remediation": sprintf("Remove the 'aws_s3_bucket_website_configuration' resource '%s'.", [name]),
		"remediationType": "manual",
	}
}