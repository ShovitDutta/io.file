package Cx
 
import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   regionalsecret := input.document[i].resource.google_secret_manager_regional_secret[name]
   actuallocation := regionalsecret.location
   expectedFromregionlist := ["us-east4", "us-west2", "us-central1"]
   not common_lib.inArray(expectedFromregionlist, actuallocation)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_secret_manager_regional_secret",
     "resourceName": tf_lib.get_resource_name(regionalsecret, name),
     "searchKey": sprintf("google_secret_manager_regional_secret[%s].location", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_secret_manager_regional_secret[%s].location should be defined and set US regions", [name]),
     "keyActualValue": sprintf("google_secret_manager_regional_secret[%s].location is set as non approved region", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_secret_manager_regional_secret", name, "location"], []),
     "remediation": "define and set only US region",
     "remediationType": "update",
  }
}