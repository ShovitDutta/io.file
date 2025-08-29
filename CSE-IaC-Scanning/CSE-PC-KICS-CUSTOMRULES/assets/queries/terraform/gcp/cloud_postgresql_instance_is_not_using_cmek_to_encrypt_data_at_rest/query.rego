package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    dbinstance := input.document[i].resource.google_sql_database_instance[name]
    object.get(dbinstance, "encryption_key_name", "undefined") == "undefined"

    result := {
        "documentId": input.document[i].id,
        "searchKey": sprintf("google_sql_database_instance[%s].encryption_key_name", [name]),
        "issueType": "MissingAttribute",
		"searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name], []),
        "keyExpectedValue": "google_sql_database_instance.encryption_key_name should be defined",
        "keyActualValue": "google_sql_database_instance.encryption_key_name is undefined",
        "remediation": "Define encryption_key_name",
        "remediationType": "addition"
    }
}

CxPolicy[result] {
  dbinstance := input.document[i].resource.google_sql_database_instance[name]
  contains(dbinstance.database_version,"POSTGRES")
  not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",dbinstance.encryption_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_sql_database_instance",
     "resourceName": tf_lib.get_resource_name(dbinstance, name),
     "searchKey": sprintf("google_sql_database_instance[%s].encryption_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_sql_database_instance[%s].encryption_key_name should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_sql_database_instance[%s].encryption_key_name is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_sql_database_instance", name, "encryption_key_name"], []),
     "remediation": "Attach a valid CMEK",
     "remediationType": "update",
  }
}