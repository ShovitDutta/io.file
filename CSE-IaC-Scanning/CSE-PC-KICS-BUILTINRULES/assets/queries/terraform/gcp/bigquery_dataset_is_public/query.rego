package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib


# Policy to check if BigQuery dataset access is publicly accessible
CxPolicy[result] {
	resource := input.document[i].resource.google_bigquery_dataset[name]
	publiclyAccessible(resource.access)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_bigquery_dataset",
		"resourceName": tf_lib.get_specific_resource_name(resource, "google_bigquery_dataset", name),
		"searchKey": sprintf("google_bigquery_dataset[%s].access.special_group", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access.special_group' should not equal to 'allAuthenticatedUsers'",
		"keyActualValue": "'access.special_group' is equal to 'allAuthenticatedUsers'",
		"searchLine": common_lib.build_search_line(["resource","google_bigquery_dataset", name],["access", "special_group"]),
		"remediation": "Remove 'allAuthenticatedUsers' from 'access.special_group' to restrict public access.",
		"remediationType": "update",
	}
}


publiclyAccessible(access) {
	is_array(access)
	some i
	access[i].special_group == "allAuthenticatedUsers"
}
