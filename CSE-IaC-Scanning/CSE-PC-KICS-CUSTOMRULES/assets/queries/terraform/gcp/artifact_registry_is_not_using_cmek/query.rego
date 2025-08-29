package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  artifactRegistry := input.document[i].resource.google_artifact_registry_repository[name]
  not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",artifactRegistry.kms_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_artifact_registry_repository",
     "resourceName": tf_lib.get_resource_name(artifactRegistry, name),
     "searchKey": sprintf("google_artifact_registry_repository[%s].kms_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_artifact_registry_repository[%s].kms_key_name should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_artifact_registry_repository[%s].kms_key_name is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_artifact_registry_repository", name, "kms_key_name"], []),
     "remediation": "Attach a valid CMEK",
     "remediationType": "update",
  }
}