package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# This policy checks if the service account configuration for a Google Compute Instance has the 'cloud-platform' scope
CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	service_account := resource.service_account
    some k, j
	endswith(service_account[k].scopes[j], "cloud-platform")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account.scopes", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account.scopes' should not contain 'cloud-platform'",
		"keyActualValue": "'service_account.scopes' contains 'cloud-platform'",
		"searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name], ["service_account", "scopes"]),
	}
}


