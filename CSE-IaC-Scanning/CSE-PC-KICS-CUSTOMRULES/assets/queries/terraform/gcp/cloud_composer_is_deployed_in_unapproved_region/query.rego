package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   composerenv := input.document[i].resource.google_composer_environment[name]
   actualregion := composerenv.region
   expectedFromregionlist := ["us-east4", "us-west2", "us-central1"]
   not common_lib.inArray(expectedFromregionlist, actualregion)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_composer_environment",
     "resourceName": tf_lib.get_resource_name(composerenv, name),
     "searchKey": sprintf("google_composer_environment[%s].region", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_composer_environment[%s].region should be defined and set US regions", [name]),
     "keyActualValue": sprintf("google_composer_environment[%s].region is set as non approved region", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "region"], []),
     "remediation": "define and set only US region",
     "remediationType": "update",
  }
}