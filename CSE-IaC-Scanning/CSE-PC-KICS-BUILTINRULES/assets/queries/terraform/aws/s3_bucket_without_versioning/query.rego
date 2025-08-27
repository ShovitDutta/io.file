package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Helper fucntion to check if bucket has versioning configured

s3_bucket_has_versioning(bucketName, doc_idx) {
    versioning := input.document[doc_idx].resource.aws_s3_bucket_versioning[_]
    versioning.bucket == input.document[doc_idx].resource.aws_s3_bucket[bucketName].bucket
}

# Check if versioning attribute Defined 
CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    not common_lib.valid_key(s3bucket, "versioning") 
    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", bucketName),
        "searchKey": sprintf("aws_s3_bucket[%s].versioning", [bucketName]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_s3_bucket[%s].versioning should be defined and not null", [bucketName]),
        "keyActualValue": sprintf("aws_s3_bucket[%s].versioning is undefined or null", [bucketName]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
        "remediation": sprintf("Add the 'versioning' block to the 'aws_s3_bucket' resource '%s'.", [bucketName]),
        "remediationType": "Manual",
    }
}

# Check if versioning configuration defined 
CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]

    not s3_bucket_has_versioning(bucketName, i)
    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		  "resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", bucketName),
        "searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_s3_bucket_versioning should be configured for aws_s3_bucket[%s]", [bucketName]),
        "keyActualValue": sprintf("aws_s3_bucket_versioning not configured for aws_s3_bucket[%s]", [bucketName]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
        "remediation": sprintf("Ensure that the 'aws_s3_bucket_versioning' resource '%s' is correctly associated with the 'aws_s3_bucket' resource.", [bucketName]),
        "remediationType": "Manual",
    }
}


# Check if versioning is enabled

CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[name]

    s3bucket_versioning  := s3bucket.versioning[k]
    s3bucket_versioning.enabled == false

    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", name),
        "searchKey": sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket[%s].versioning.enabled should be true", [name]),
        "keyActualValue": sprintf("aws_s3_bucket[%s].versioning.enabled is set to false" , [name]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", "enabled"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
    }
}


# Check if versioning configuration status is Enabled

CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    bucket_versioning_conf := input.document[i].resource.aws_s3_bucket_versioning[name]

    bucket_versioning_conf.bucket == s3bucket.bucket
    # get versioning configuration status
    versioning_status := bucket_versioning_conf.versioning_configuration[k]
    lower(versioning_status.status) != "enabled"

    bucket_name := bucket_versioning_conf.bucket

    result := {
        "documentId": input.document[i].id,
       "resourceType": "aws_s3_bucket_versioning",
		"resourceName": tf_lib.get_resource_name(bucket_versioning_conf, name),
        "searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status should be set to 'Enabled'", [name]),
        "keyActualValue": "'versioning_configuration.status' is not 'Enabled'",
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "status"], []),
        "remediation": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status should be set to 'Enabled'.", [name]),
		"remediationType": "Manual",
    }
}