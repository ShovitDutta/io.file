package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Helper function to determine if a bucket has logging configured aws_s3_bucket_logging

s3_bucket_has_logging(bucketName, doc_idx) {
    logging := input.document[doc_idx].resource.aws_s3_bucket_logging[_]
    logging.bucket == input.document[doc_idx].resource.aws_s3_bucket[bucketName].bucket
}


CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    not common_lib.valid_key(s3bucket, "logging") 
    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", bucketName),
        "searchKey": sprintf("aws_s3_bucket[%s].logging", [bucketName]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_s3_bucket[%s].logging should be defined and not null", [bucketName]),
        "keyActualValue": sprintf("aws_s3_bucket[%s].logging is undefined or null", [bucketName]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
        "remediation": sprintf("Add the 'logging' block to the 'aws_s3_bucket' resource '%s'.", [bucketName]),
        "remediationType": "Manual",
    }
}


CxPolicy[result] {
    s3bucket := input.document[i].resource.aws_s3_bucket[bucketName]

    not s3_bucket_has_logging(bucketName, i)
    bucket_name := s3bucket.bucket

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket, "aws_s3_bucket", bucketName),
        "searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_s3_bucket_logging should be configured for aws_s3_bucket[%s]", [bucketName]),
        "keyActualValue": sprintf("aws_s3_bucket_logging not configured for aws_s3_bucket[%s]", [bucketName]),
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
        "remediation": sprintf("Ensure that the 'aws_s3_bucket_logging' resource '%s' is correctly associated with the 'aws_s3_bucket' resource.", [bucketName]),
        "remediationType": "Manual",
    }
}