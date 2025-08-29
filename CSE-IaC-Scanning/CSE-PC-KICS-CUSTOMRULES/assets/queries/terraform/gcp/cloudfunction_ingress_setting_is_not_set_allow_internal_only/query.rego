package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name]
   cloudfunctionsrv_service_config := cloudfunctionsrv.service_config
   count(cloudfunctionsrv_service_config) == 0   
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_cloudfunctions2_function",
     "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
     "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.ingress_settings should be defined and set ALLOW_INTERNAL_ONLY ", [name]),
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.ingress_settings is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config"], []),
     "remediation": "define and set ingress_settings as ALLOW_INTERNAL_ONLY",
     "remediationType": "addition",
  }
}


CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].service_config[j]
   upper(cloudfunctionsrv.ingress_settings) != "ALLOW_INTERNAL_ONLY"
   result := {
      "documentId": input.document[i].id,
      "resourceType": "google_cloudfunctions2_function",
      "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
      "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config.ingress_settings", [name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.ingress_settings should be defined and set ALLOW_INTERNAL_ONLY ", [name]),
      "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.ingress_settings is undefined or not set ALLOW_INTERNAL_ONLY", [name]),
      "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config", "ingress_settings"], []),
      "remediation": "set ingress_settings as ALLOW_INTERNAL_ONLY",
      "remediationType": "replacement",
   }
}