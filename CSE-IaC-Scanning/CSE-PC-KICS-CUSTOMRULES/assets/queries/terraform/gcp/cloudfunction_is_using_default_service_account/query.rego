package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].build_config[j]
   contains(cloudfunctionsrv.service_account, "@developer.gserviceaccount.com")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_cloudfunctions2_function",
     "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
     "searchKey": sprintf("google_cloudfunctions2_function[%s].build_config.service_account", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].build_config.service_account should not be  defined with default( developer) service account", [name]), 
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].build_config.service_account is defined with default( developer) service account", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "build_config", "service_account"], []),
     "remediation": "define a non default service account",
     "remediationType": "update",
  }
}