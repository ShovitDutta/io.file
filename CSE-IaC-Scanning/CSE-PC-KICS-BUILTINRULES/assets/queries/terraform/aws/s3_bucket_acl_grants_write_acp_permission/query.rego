package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	s3bucket_acl := input.document[i].resource.aws_s3_bucket_acl[name]

	acl_policy_grant := s3bucket_acl.access_control_policy[k].grant[grant_index]

	contains(lower(acl_policy_grant.permission), "write_acp")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_specific_resource_name(s3bucket_acl, "aws_s3_bucket_acl", name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant.permission", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant.permission should not be granted other than Read or Read_ACP permission.", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s].access_control_policy.grant.permission granted WRITE_ACP", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "access_control_policy", "grant", "permission"], []),
		"remediation": sprintf("To resolve this issue, modify the aws_s3_bucket_acl[%s] to ensure that the access_control_policy.grant.permission is set to 'Read' or 'Read_ACP' only.", [name]),
		"remediationType": "Manual",
	}
}