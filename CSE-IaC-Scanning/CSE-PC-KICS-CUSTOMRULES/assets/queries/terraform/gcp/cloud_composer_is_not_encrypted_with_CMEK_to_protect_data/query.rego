package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  composerenv := input.document[i].resource.google_composer_environment[name].config[k]
  object.get(composerenv, "encryption_config", "undefined") == "undefined"

  result := {
        "documentId": input.document[i].id,
        "resourceType": "google_composer_environment",
        "searchKey": sprintf("google_composer_environment[%s].config", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "Cloud Composer encryption config KMS key name should be defined",
        "keyActualValue": "Cloud Composer encryption config KMS key name is undefined",
        "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name], []),
        "remediation": "Define encryption_config under google_composer_environment",
        "remediationType": "addition"
    }
}

CxPolicy[result] {
  composerenv := input.document[i].resource.google_composer_environment[name].config[k]
  encryptionconfigobj := composerenv.encryption_config[j]
  encryptionconfigobj.kms_key_name == null

  result := {
        "documentId": input.document[i].id,
        "resourceType": "google_composer_environment",
        "resourceName": tf_lib.get_resource_name(composerenv, name),
        "searchKey": sprintf("google_composer_environment[%s].config.encryption_config.kms_key_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Cloud Composer KMS key name should be defined",
        "keyActualValue": "Cloud Composer KMS key name is null or empty",
        "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "config"], []),
        "remediation": "set a valid kms_key_name under google_composer_environment",
        "remediationType": "update"
    }
}

CxPolicy[result] {
  composerenv := input.document[i].resource.google_composer_environment[name].config[k]
  encryptionconfigobj := composerenv.encryption_config[j]
  not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",encryptionconfigobj.kms_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_composer_environment",
     "resourceName": tf_lib.get_resource_name(composerenv, name),
     "searchKey": sprintf("google_composer_environment[%s].config.encryption_config.kms_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_composer_environment[%s].config.encryption_config should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_composer_environment[%s].config.encryption_config is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "config"], []),
     "remediation": "Attach a valid CMEK under encryption_config",
     "remediationType": "update",
  }
}