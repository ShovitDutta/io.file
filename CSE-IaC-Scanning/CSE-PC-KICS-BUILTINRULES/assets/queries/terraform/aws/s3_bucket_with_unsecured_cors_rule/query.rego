package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Check the S3 bucket has a CORS rule 
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]

	rule := bucket.cors_rule[k]
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].cors_rule to not allow all methods, all headers or several origins", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].cors_rule allows all methods, all headers or several origins", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "cors_rule"], []),
        "remediation": sprintf("Remove the 'cors_rule' that allows all methods, all headers or several origins from the 'aws_s3_bucket' resource '%s'.", [name]),
        "remediationType": "manual",
	}
}


# Check if the S3 bucket has a CORS rule configured

CxPolicy[result] {

    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
	s3_cors_configuration := input.document[i].resource.aws_s3_bucket_cors_configuration[name]

    # check if bucket names match
    s3_cors_configuration.bucket == s3bucket.bucket

    # get cors rules from the S3 bucket CORS configuration
	rule := s3_cors_configuration.cors_rule[k]

    # check if the CORS rule allows all methods, all headers or several origins
	common_lib.unsecured_cors_rule(rule.allowed_methods, rule.allowed_headers, rule.allowed_origins)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_cors_configuration",
		"resourceName": tf_lib.get_specific_resource_name(s3_cors_configuration, "aws_s3_bucket_cors_configuration", name),
		"searchKey": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule to not allow all methods, all headers or several origins", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_cors_configuration[%s].cors_rule allows all methods, all headers or several origins", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_cors_configuration", name, "cors_rule"], []),
        "remediation": sprintf("Remove the 'cors_rule' that allows all methods, all headers or several origins from the 'aws_s3_bucket_cors_configuration' resource '%s'.", [name]),
        "remediationType": "manual",
	}
}