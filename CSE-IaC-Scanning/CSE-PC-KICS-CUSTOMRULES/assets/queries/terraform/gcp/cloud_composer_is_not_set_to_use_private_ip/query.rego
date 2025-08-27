package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  composerenv := input.document[i].resource.google_composer_environment[name].config[k]
  softwareconfig := composerenv.software_config[j]
  softwareconfig.image_version == "composer-3-airflow-2"
  object.get(composerenv, "enable_private_environment", "undefined") == "undefined"

  result := {
        "documentId": input.document[i].id,
        "resourceType": "google_composer_environment",
        "searchKey": sprintf("google_composer_environment[%s].config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloud Composer encryption config enable_private_environment should be defined",
        "keyActualValue": "Cloud Composer encryption config enable_private_environment is undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "config"], []),
        "remediation": "Define enable_private_environment under google_composer_environment",
        "remediationType": "addition"
    }
}


CxPolicy[result] {
  composerenv := input.document[i].resource.google_composer_environment[name].config[k]
  softwareconfig := composerenv.software_config[j]
  softwareconfig.image_version == "composer-3-airflow-2"
  composerenv.enable_private_environment == false

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_composer_environment",
     "resourceName": tf_lib.get_resource_name(composerenv, name),
     "searchKey": sprintf("google_composer_environment[%s].config", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_composer_environment[%s].config.enable_private_environment should set to true", [name]),
     "keyActualValue": sprintf("google_composer_environment[%s].config.enable_private_environment is set to false", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "config", "enable_private_environment"], []),
     "remediation": "set enable_private_environment to true",
     "remediationType": "update",
  }
}