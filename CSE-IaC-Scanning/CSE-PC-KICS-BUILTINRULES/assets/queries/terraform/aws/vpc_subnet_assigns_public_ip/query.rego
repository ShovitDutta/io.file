package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_subnet[name]

	resource.map_public_ip_on_launch == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_subnet",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_subnet[%s].map_public_ip_on_launch", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_subnet[%s].map_public_ip_on_launch should be set to false or undefined", [name]),
		"keyActualValue": sprintf("aws_subnet[%s].map_public_ip_on_launch is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_subnet", name, "map_public_ip_on_launch"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}


