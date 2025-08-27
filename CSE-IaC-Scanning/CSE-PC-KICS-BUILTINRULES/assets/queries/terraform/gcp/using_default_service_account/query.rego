package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib



# This policy checks if the service account email is a default Google Compute Engine service account
CxPolicy[result] {
	resource := input.document[i].resource.google_compute_instance[name]
	contains(resource.service_account[k].email, "@developer.gserviceaccount.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_instance[%s].service_account.email", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_instance[%s].service_account.email' should not be a default Google Compute Engine service account", [name]),
		"keyActualValue": sprintf("'google_compute_instance[%s].service_account.email' is a default Google Compute Engine service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_instance", name, "service_account"], []),
	}
}


