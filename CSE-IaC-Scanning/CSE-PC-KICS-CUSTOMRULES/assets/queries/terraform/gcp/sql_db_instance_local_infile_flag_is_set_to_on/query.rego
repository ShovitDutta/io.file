# package Cx

# import data.generic.common as common_lib
# import data.generic.terraform as tf_lib

# CxPolicy[result] {
#         dbinstance := input.document[i].resource.google_sql_database_instance[name]
#         contains(dbinstance.database_version,"MYSQL")
#         dbflagsettings = dbinstance.settings[k].database_flags
#         not indbflag_array(dbflagsettings,"local_infile", "off")
#         result := {
#                 "documentId": input.document[i].id,
#                 "resourceType": "google_sql_database_instance",
#                 "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
#                 "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags.local_infile", [name]),
# 		"issueType": "IncorrectValue",
#                 "keyExpectedValue": "settings.database_flags should have configuration for local_infile and value set to off",
#                 "keyActualValue": "settings.database_flags doesn't have configuration for local_infile and value is set to on",
#                 "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings","database_flags","local_infile"],[]),
#                 "remediation": "define local_infile and set it off under settings in database_flags",
#                 "remediationType": "update"
#         }
# }

# indbflag_array(field,expname, expvalue){
#   some i
#   field[i].name == expname
#   field[i].value == expvalue
# }

package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
        contains(dbinstance.database_version,"MYSQL")
        dbflagsettings = dbinstance.settings[k].database_flags
        not indbflag_array(dbflagsettings,"local_infile", "off")
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s].settings.database_flags", [name]),
                "issueType": "IncorrectValue",
                "keyExpectedValue": "settings.database_flags should have configuration for local_infile and value set to off",
                "keyActualValue": "settings.database_flags doesn't have configuration for local_infile and value is set to on",
                "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "settings","database_flags"],[]),
                "remediation" : "set the local_infile flag to off under settings",
                "remediationType": "update"
        }
}

indbflag_array(field,expname, expvalue){
  some i
  field[i].name == expname
  field[i].value == expvalue
}
