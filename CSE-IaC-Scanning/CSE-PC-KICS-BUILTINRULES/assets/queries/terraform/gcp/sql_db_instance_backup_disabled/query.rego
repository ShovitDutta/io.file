package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# This policy checks if the backup_configuration is defined and enabled for Google SQL Database Instances.
CxPolicy[result] {
        resource := input.document[i].resource.google_sql_database_instance[name].settings[k]
        not common_lib.valid_key(resource, "backup_configuration")

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": "settings.backup_configuration should be defined and not null",
                "keyActualValue": "settings.backup_configuration is undefined or null",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name,"settings"],[]),
        }
}

# This policy checks if the backup_configuration.enabled is defined & not null and set to true for Google SQL Database Instances.
CxPolicy[result] {
        backup_conf := input.document[i].resource.google_sql_database_instance[name].settings[k].backup_configuration[j]
        common_lib.emptyOrNull(backup_conf.enabled)

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "settings.backup_configuration.enabled should be defined and not null in settings.backup_configuration",
                "keyActualValue": "settings.backup_configuration.enabled is undefined or null in settings.backup_configuration",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "backup_configuration", "enabled"]),
                "remediation": "enabled = true",
                "remediationType": "addition",
        }
}


# This policy checks if the backup_configuration.enabled is set to false & should be true for Google SQL Database Instances.
CxPolicy[result] {
        backup_conf := input.document[i].resource.google_sql_database_instance[name].settings[k].backup_configuration[j]
        backup_conf.enabled == false
        
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.backup_configuration.enabled", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "settings.backup_configuration.enabled should be true",
                "keyActualValue": "settings.backup_configuration.enabled is false",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "backup_configuration", "enabled"]),
                "remediation": json.marshal({
                        "before": "false",
                        "after": "true"
                }),
                "remediationType": "replacement",
        }
}

