package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
	contains(dbinstance.database_version,"POSTGRES")
        settings := dbinstance.settings[j]
        ip_configuration := settings.ip_configuration[k]
        not common_lib.valid_key(ip_configuration, "private_network")

        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name].settings, name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.ip_configuration", [name]),
                "issueType": "MissingAttribute",
                "keyExpectedValue": "'settings.ip_configuration.private_network' should be defined and not null",
                "keyActualValue": "'settings.ip_configuration.private_network' is undefined or null",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name],["settings", "ip_configuration"]),
                "remediation": "define private_network",
                "remediationType": "addition",
        }
}