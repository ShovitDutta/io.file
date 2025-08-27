package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
        dbinstance := input.document[i].resource.google_sql_database_instance[name]
        contains(dbinstance.database_version,"POSTGRES")
        dbflagsettings = dbinstance.settings[k].database_flags
        is_array(dbflagsettings)
        not indbflag_array(dbflagsettings,"cloudsql.iam_authentication", "on")
        result := {
                "documentId": input.document[i].id,
                "resourceType": "google_sql_database_instance",
                "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_sql_database_instance[name], name),
                "searchKey": sprintf("google_sql_database_instance[%s]", [name]),
		"issueType": "IncorrectValue",
                "keyExpectedValue": "settings.database_flags should have configuration for local_infile and value set to off",
                "keyActualValue": "settings.database_flags doesn't have configuration for local_infile and value is set to on",
        }
}

indbflag_array(field,expname, expvalue){
  some i
  field[i].name == expname
  field[i].value == expvalue
}