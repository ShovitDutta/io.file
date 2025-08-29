package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	not common_lib.valid_key(resource, "monitoring")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s].monitoring should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_instance[%s].monitoring is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
		"remediation": "monitoring = true",
		"remediationType": "addition",
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	resource.monitoring == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].monitoring should be set to true", [name]),
		"keyActualValue": sprintf("aws_instance[%s].monitoring is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "monitoring"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}