package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"SQLSERVER")
	dbsettings = dbinstance.settings[j].ip_configuration[k]
	not common_lib.valid_key(dbsettings, "ssl_mode")

	result := {
			"documentId": input.document[i].id,
			"resourceType": "google_sql_database_instance",
			"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
			"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
			"issueType": "MissingAttribute",
			"keyExpectedValue": sprintf("google_sql_database_instance[%s].settings.ip_configuration should.ssl_mode be defined and should have ENCRYPTED_ONLY value", [name]),
			"keyActualValue": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode is undefined or null", [name]),
			"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name,"settings","ip_configuration"],[]),
			"remediation": "Define ssl_mode with value as ENCRYPTED_ONLY",
			"remediationType": "addition"
	}
}

CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"SQLSERVER")
	upper(dbinstance.settings[j].ip_configuration[k].ssl_mode) != "ENCRYPTED_ONLY"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode", [name]),
		"issueType": "UpdateAttribute",
		"keyExpectedValue": sprintf("google_sql_database_instance[%s].settings.ip_configuration should.ssl_mode be defined and should have ENCRYPTED_ONLY value", [name]),
		"keyActualValue":sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode doesn't have ENCRYPTED_ONLY value", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name,"settings","ip_configuration","ssl_mode"],[]),
		"remediation": "set ssl_mode as ENCRYPTED_ONLY",
		"remediationType": "Update"
	}
}