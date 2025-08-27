package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Check if bucket versioning has mfa delete enabled
CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[name]

    s3bucket_versioning  := s3bucket.versioning[k]
    s3bucket_versioning.mfa_delete == false

    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", name),
        "searchKey": sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket[%s].versioning.mfa_delete should be true", [name]),
        "keyActualValue": sprintf("aws_s3_bucket[%s].versioning.mfa_delete is set to false" , [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", "mfa_delete"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
    }
}

# Chekc if versioning conf has mfa delete attribute
CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    bucket_versioning_conf := input.document[i].resource.aws_s3_bucket_versioning[name]

    bucket_versioning_conf.bucket == s3bucket.bucket
    # get versioning configuration status
    versioning_mfa := bucket_versioning_conf.versioning_configuration[k]
    not common_lib.valid_key(versioning_mfa, "mfa_delete")

    bucket_name := bucket_versioning_conf.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket_versioning",
		"resourceName": tf_lib.get_resource_name(bucket_versioning_conf, name),
        "searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete should be set to 'Enabled'", [name]),
        "keyActualValue":  sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete is not Defined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration"], []),
        "remediation": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete should be set to 'Enabled'.", [name]),
		"remediationType": "Manual",
    }
}


# Check if versioning conf has mfa delete attribute set to Enabled

CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    bucket_versioning_conf := input.document[i].resource.aws_s3_bucket_versioning[name]

    bucket_versioning_conf.bucket == s3bucket.bucket
    # get versioning configuration status
    versioning_mfa := bucket_versioning_conf.versioning_configuration[k]
    lower(versioning_mfa.mfa_delete) != "enabled"

    bucket_name := bucket_versioning_conf.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket_versioning",
		"resourceName": tf_lib.get_resource_name(bucket_versioning_conf, name),
        "searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete should be set to 'Enabled'", [name]),
        "keyActualValue":  sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.mfa_delete is not 'Enabled'", [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "mfa_delete"], []),
        "remediation": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration should be set to 'Enabled'.", [name]),
		"remediationType": "Manual",
    }
}