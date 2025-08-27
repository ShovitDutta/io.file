package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        settings := input.document[i].resource.google_sql_database_instance[name].settings[j]
        
        not common_lib.valid_key(settings, "ip_configuration")

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": "'settings.ip_configuration' should be defined and not null",
                "keyActualValue": "'settings.ip_configuration' is undefined or null",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name,"settings"],[]),
                "remediation": "define ip_configuration under settings",
                "remediationType": "addition",
        }
}

CxPolicy[result] {
        settings := input.document[i].resource.google_sql_database_instance[name].settings[j]
        ip_configuration := settings.ip_configuration[k]

        not common_lib.valid_key(ip_configuration, "ssl_mode")

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": "'settings.ip_configuration.ssl_mode' should be defined and not null",
                "keyActualValue": "'settings.ip_configuration.ssl_mode' is undefined or null",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "ip_configuration"],[]),
                "remediation": "define ssl_mode under ip_configuration",
                "remediationType": "addition",
        }
}

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"MYSQL")
        settings := input.document[i].resource.google_sql_database_instance[name].settings[j]
        actual_ssl_mode := settings.ip_configuration[k].ssl_mode
        expected_ssl_mode := ["TRUSTED_CLIENT_CERTIFICATE_REQUIRED", "ENCRYPTED_ONLY"]
        not common_lib.inArray(expected_ssl_mode, actual_ssl_mode)

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "'settings.ip_configuration.ssl_mode' should be either TRUSTED_CLIENT_CERTIFICATE_REQUIRED or ENCRYPTED_ONLY",
                "keyActualValue": "'settings.ip_configuration.ssl_mode' is not set to either TRUSTED_CLIENT_CERTIFICATE_REQUIRED or ENCRYPTED_ONLY",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "ip_configuration","ssl_mode"],[]),
                "remediation": "set ssl_mode = TRUSTED_CLIENT_CERTIFICATE_REQUIRED or ENCRYTPED_ONLY",
                "remediationType": "replacement",
        }
}

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"POSTGRES")
        settings := input.document[i].resource.google_sql_database_instance[name].settings[j]
        actual_ssl_mode := settings.ip_configuration[k].ssl_mode
        expected_ssl_mode := ["TRUSTED_CLIENT_CERTIFICATE_REQUIRED", "ENCRYPTED_ONLY"]
        not common_lib.inArray(expected_ssl_mode, actual_ssl_mode)

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration.ssl_mode", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "'settings.ip_configuration.ssl_mode' should be either ENCRYTPED_ONLY OR TRUSTED_CLIENT_CERTIFICATE_REQUIRED",
                "keyActualValue": "'settings.ip_configuration.ssl_mode' is not set to ENCRYPTED_ONLY OR TRUSTED_CLIENT_CERTIFICATE_REQUIRED",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings", "ip_configuration","ssl_mode"],[]),
                "remediation": "set ssl_mode = ENCRYTPED_ONLY or TRUSTED_CLIENT_CERTIFICATE_REQUIRED",
                "remediationType": "replacement",
        }
}