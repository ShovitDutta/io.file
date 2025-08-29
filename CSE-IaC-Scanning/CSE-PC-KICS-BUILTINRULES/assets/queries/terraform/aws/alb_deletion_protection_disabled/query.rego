package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

lbs := {"aws_lb", "aws_alb"}

CxPolicy[result] {
	loadBalancer := lbs[l]
	lb := input.document[i].resource[loadBalancer][name]

	lb.enable_deletion_protection == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": loadBalancer,
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("%s[%s].enable_deletion_protection", [loadBalancer, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enable_deletion_protection' should be set to true",
		"keyActualValue": "'enable_deletion_protection' is set to false",
		"searchLine": common_lib.build_search_line(["resource", loadBalancer, name, "enable_deletion_protection"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}