package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"SQLSERVER")
	dbsettings = dbinstance.settings[j].ip_configuration[k]
	
	common_lib.emptyOrNull(dbsettings.private_network)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.private_network", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_sql_database_instance[%s].settings.ip_configuration.private_network should be defined and not null", [name]),
		"keyActualValue": sprintf("google_sql_database_instance[%s].settings.ip_configuration.private_network is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings","ip_configuration", "private_network"],[]),
		"remediation": "Define private_network",
		"remediationType": "addition"
	}
}