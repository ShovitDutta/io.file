package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"SQLSERVER")
	not common_lib.valid_key(dbinstance, "encryption_key_name")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].encryption_key_name", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_sql_database_instance[%s].encryption_key_name should be defined and not null", [name]),
		"keyActualValue": sprintf("google_sql_database_instance[%s].encryption_key_name is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],[]),
		"remediation": "encryption_key_name should be defined and set the CMEK",
		"remediationType": "addition"
	}
}