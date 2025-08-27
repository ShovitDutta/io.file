package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.publicly_accessible

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'publicly_accessible' should be set to false or undefined",
		"keyActualValue": "'publicly_accessible' is set to true",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "publicly_accessible"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}