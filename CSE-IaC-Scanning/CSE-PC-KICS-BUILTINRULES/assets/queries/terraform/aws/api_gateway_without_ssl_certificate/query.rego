package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_stage[name]

	common_lib.emptyOrNull(resource.client_certificate_id)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s].client_certificate_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s].client_certificate_id should be set", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s].client_certificate_id is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name, "client_certificate_id"], []),
		"remediation": "Add a valid client certificate to the API Gateway stage.",
		"remediationType": "addition",
	}
}
