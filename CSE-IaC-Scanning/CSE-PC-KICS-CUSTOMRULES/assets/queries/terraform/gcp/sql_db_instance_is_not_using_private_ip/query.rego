package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	sqldbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(sqldbinstance.database_version,"MYSQL")
	not common_lib.valid_key(sqldbinstance, "private_ip_address")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].ip_address.0.type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "private_ip_address should be defined and not null",
		"keyActualValue": "private_ip_address is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],[]),
	}
}