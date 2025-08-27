package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

# Policy to check if master_auth is defined and not null
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
    not common_lib.valid_key(resource,"master_auth")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_compute_instance[%s].master_auth should be set", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].master_auth is undefined", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
	}
}

# Policy to check if master_auth.client_certificate_config is defined and not null
CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	cluster_master_auth := resource.master_auth[k]
    client_certificate_config := cluster_master_auth.client_certificate_config[m]
	client_certificate_config.issue_client_certificate == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].master_auth.client_certificate_config.issue_client_certificate", [name]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("google_compute_instance[%s].master_auth.client_certificate_config.issue_client_certificate should be false", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].master_auth.client_certificate_config.issue_client_certificate should be true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], ["master_auth","client_certificate_config"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}