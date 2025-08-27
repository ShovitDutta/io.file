package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name]
  common_lib.emptyOrNull(cloudfunctionsrv.kms_key_name)

  result := {
    "documentId": input.document[i].id,
    "resourceType": "google_cloudfunctions2_function",
    "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
    "searchKey": sprintf("google_cloudfunctions2_function[%s].kms_key_name", [name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].kms_key_name should be defined and encrypt with CMEK", [name]),
    "keyActualValue": sprintf("google_cloudfunctions2_function[%s].kms_key_name is undefined", [name]),
    "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "kms_key_name"], []),
    "remediation": "define kms_key_name to ensure the data is encrypted with CMEK",
    "remediationType": "addition",
  }
}