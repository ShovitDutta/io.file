package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]
	db.enabled_cloudwatch_logs_exports == null

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(db, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' should be defined",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}