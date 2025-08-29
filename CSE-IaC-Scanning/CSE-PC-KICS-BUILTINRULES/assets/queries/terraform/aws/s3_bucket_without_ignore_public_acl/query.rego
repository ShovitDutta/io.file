package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	pubACL.ignore_public_acls == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].ignore_public_acls", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_public_access_block[%s].ignore_public_acls should equal 'true'", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_public_access_block[%s].ignore_public_acls is equal 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "ignore_public_acls"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


