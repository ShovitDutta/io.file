package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib



CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	value := resource.retention_in_days
	validValues := [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653]
	count({x | validValues[x]; validValues[x] == value}) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudwatch_log_group[%s].retention_in_days", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_cloudwatch_log_group", name, "retention_in_days"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_cloudwatch_log_group[%s].retention_in_days should be set and valid values is days(refer Documentation)", [name]),
		"keyActualValue": sprintf("aws_cloudwatch_log_group[%s].retention_in_days is set but invalid", [name]),
		"remediation": "Set the retention_in_days attribute to one of the valid values(refer Documentation)",
		"remediationType": "replacement",
	}
}
