package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name]
   actualLocation := cloudfunctionsrv.location
   expectedFromLocationlist := ["us-east4", "us-west2", "us-central1"]
   not common_lib.inArray(expectedFromLocationlist, actualLocation)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_cloudfunctions2_function",
     "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
     "searchKey": sprintf("google_cloudfunctions2_function[%s].location", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].location should be defined and set US locations", [name]),
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].location is set as non approved location", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "location"], []),
     "remediation": "define and set only US location",
     "remediationType": "update",
  }
}