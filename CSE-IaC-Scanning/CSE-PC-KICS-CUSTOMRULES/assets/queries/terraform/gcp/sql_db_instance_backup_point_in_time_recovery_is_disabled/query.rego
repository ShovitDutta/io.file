package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
	dbinstancesettings := input.document[i].resource.google_sql_database_instance[name].settings[j]
	not common_lib.valid_key(dbinstancesettings, "backup_configuration")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration should be defined and not null",
		"keyActualValue": "settings.backup_configuration is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"],[]),
	}
}

CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
	dbinstancesettings := input.document[i].resource.google_sql_database_instance[name].settings[j]
	dbbackupconfig := dbinstancesettings.backup_configuration[k]
	not common_lib.valid_key(dbbackupconfig, "enabled")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration.enabled should be defined and not null",
		"keyActualValue": "settings.backup_configuration.enabled is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"],[]),
	}
}



CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
	dbsettings = dbinstance.settings[j]
	dbsettings.backup_configuration[k].enabled == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Ptest settings.backup_configuration.enabled should be true",
		"keyActualValue": "Ptest settings.backup_configuration.enabled is false",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"],[]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}


CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
	dbinstancesettings := input.document[i].resource.google_sql_database_instance[name].settings[j]
	dbbackupconfig := dbinstancesettings.backup_configuration[k]
	not common_lib.valid_key(dbbackupconfig, "binary_log_enabled")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "settings.backup_configuration.binary_log_enabled should be defined and not null",
		"keyActualValue": "settings.backup_configuration.binary_log_enabled is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings"],[]),
	}
}

CxPolicy[result] {
	dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
	dbsettings = dbinstance.settings[j]
	dbsettings.backup_configuration[k].binary_log_enabled == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_sql_database_instance",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
		"searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.binary_log_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "PTest settings.backup_configuration.binary_log_enabled should be true",
		"keyActualValue": "PTest settings.backup_configuration.binary_log_enabled is false",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "backup_configuration", "binary_log_enabled"],[]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}