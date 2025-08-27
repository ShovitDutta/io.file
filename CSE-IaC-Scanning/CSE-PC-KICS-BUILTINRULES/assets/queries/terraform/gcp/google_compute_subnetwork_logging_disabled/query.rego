package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_subnetwork[name]	
	count(resource.log_config) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_subnetwork",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_subnetwork[%s].log_config", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_subnetwork[%s].log_config' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_subnetwork[%s].log_config' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_subnetwork", name,"log_config"],[]),
		"remediation": "log_config should be defined for google_compute_subnetwork",
		"remediationType": "addition",
	}
}
