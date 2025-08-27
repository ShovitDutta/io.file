package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  documentai := input.document[i].resource.google_document_ai_processor[name]
  documentai.kms_key_name == null

  result := {
        "documentId": input.document[i].id,
        "resourceType": "google_document_ai_processor",
        "resourceName": tf_lib.get_resource_name(documentai, name),
        "searchKey": sprintf("google_document_ai_processor[%s].kms_key_name", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "Document AI - KMS key name should be defined",
        "keyActualValue": "Document AI - KMS key name is null or empty",
        "searchLine": common_lib.build_search_line(["resource", "google_document_ai_processor", name, "kms_key_name"], []),
        "remediation": "set a valid kms_key_name under google_document_ai_processor",
        "remediationType": "update"
    }
}

CxPolicy[result] {
  documentai := input.document[i].resource.google_document_ai_processor[name]
  not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",documentai.kms_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_document_ai_processor",
     "resourceName": tf_lib.get_resource_name(documentai, name),
     "searchKey": sprintf("google_document_ai_processor[%s].kms_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_document_ai_processor[%s].kms_key_name should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_document_ai_processor[%s].kms_key_name is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_document_ai_processor", name, "kms_key_name"], []),
     "remediation": "set a valid CMEK under kms_key_name",
     "remediationType": "update",
  }
}