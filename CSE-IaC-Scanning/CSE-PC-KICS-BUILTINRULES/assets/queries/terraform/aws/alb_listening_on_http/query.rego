package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	lb := input.document[i].resource.aws_lb[lname]
	lb.load_balancer_type == "application"
	resource := input.document[i].resource.aws_lb_listener[name]
	upper(resource.protocol) == "HTTP"
	defaultactionobj := resource.default_action[k]
	defaultactionobj.type == "redirect"
	redirectobj := defaultactionobj.redirect[m]
	redirectobj.protocol != "HTTPS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_lb_listener",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_lb_listener[%s].default_action.redirect.protocol", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_lb_listener", name, "default_action"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_lb_listener.default_action.redirect.protocol' should be equal to 'HTTPS'",
		"keyActualValue": "'aws_lb_listener.default_action.redirect.protocol' is equal 'HTTP'",
		"remediation": json.marshal({
			"before": "HTTP",
			"after": "HTTPS"
		}),
		"remediationType": "replacement",
	}
}

is_http(resource) {
	upper(resource.protocol) == "HTTP"
}

is_http(resource) {
	not common_lib.valid_key(resource, "protocol")
}