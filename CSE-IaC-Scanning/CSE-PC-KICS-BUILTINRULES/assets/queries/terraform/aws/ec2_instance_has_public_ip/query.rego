package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	not common_lib.valid_key(resource, "associate_public_ip_address")
	not common_lib.valid_key(resource, "network_interface")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s].associate_public_ip_address' should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_instance[%s].associate_public_ip_address' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
		"remediation": "Add 'associate_public_ip_address' attribute to the resource with a value of false",
		"remediationType": "Manual",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	isTrue(resource.associate_public_ip_address)
	not common_lib.valid_key(resource, "network_interface")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_instance[%s].associate_public_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].associate_public_ip_address should be set to false", [name]),
		"keyActualValue": sprintf("aws_instance[%s].associate_public_ip_address is true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "associate_public_ip_address"], []),
		"remediation": "Set 'associate_public_ip_address' attribute to false",
		"remediationType": "Manual",
	}
}



isTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
