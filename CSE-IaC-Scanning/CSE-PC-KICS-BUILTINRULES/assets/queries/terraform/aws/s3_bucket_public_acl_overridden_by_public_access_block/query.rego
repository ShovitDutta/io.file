package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	# version before TF AWS 4.0
	s3bucket := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(s3bucket.acl)

	# version after TF AWS 4.0
	publicBlockACL := input.document[i].resource.aws_s3_bucket_public_access_block[blockName]

	publicBlockACL.bucket ==  s3bucket.bucket

	public(publicBlockACL)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL to not be overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
		"remediation": sprintf("Ensure aws_s3_bucket_acl[%s]acl is not set to 'public-read' or 'public-read-write' and that the S3 bucket Public Access Block is configured correctly.", [name]),
		"remediationType": "Manual",
		
	}
}



CxPolicy[result] {
	# version before TF AWS 4.0
	s3bucket = input.document[i].resource.aws_s3_bucket[bucketName]

	s3_bucket_acl := input.document[i].resource.aws_s3_bucket_acl[name]
	s3_bucket_acl.bucket == s3bucket.bucket

	publicAccessACL(s3_bucket_acl.acl)

	# version after TF AWS 4.0
	publicBlockACL := input.document[i].resource.aws_s3_bucket_public_access_block[blockName]
	publicBlockACL.bucket == s3bucket.bucket

	public(publicBlockACL)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_resource_name(s3_bucket_acl, name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL to not be overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
		"remediation": sprintf("Ensure aws_s3_bucket_acl[%s]acl is not set to 'public-read' or 'public-read-write' and that the S3 bucket Public Access Block is configured correctly.", [name]),
		"remediationType": "Manual",
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true

public(publicBlockACL) {
	publicBlockACL.block_public_acls == true
	publicBlockACL.block_public_policy == true
	publicBlockACL.ignore_public_acls == true
	publicBlockACL.restrict_public_buckets == true
}
