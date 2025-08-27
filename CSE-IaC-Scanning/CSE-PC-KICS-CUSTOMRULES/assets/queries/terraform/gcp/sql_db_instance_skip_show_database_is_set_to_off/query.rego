package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
        contains(dbinstance.database_version,"MYSQL")
        dbflagsettings = dbinstance.settings[k].database_flags
        not indbflag_array(dbflagsettings,"skip_show_database", "on")
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "settings.database_flags should have configuration for skip_show_database and value set to on",
                "keyActualValue": "settings.database_flags doesn't have configuration for skip_show_database and value is set to off",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings","database_flags"],[]),
                "remediation" : "set the skip_show_database flag to on under settings",
                "remediationType": "update"
        }
}

indbflag_array(field,expname, expvalue){
  some i
  field[i].name == expname
  field[i].value == expvalue
}
