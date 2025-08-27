package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   composerenv := input.document[i].resource.google_composer_environment[name].config[k]
   nodeconfigobj := composerenv.node_config[j]
   contains(nodeconfigobj.service_account,"compute@developer.gserviceaccount.com")

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_composer_environment",
     "resourceName": tf_lib.get_resource_name(composerenv, name),
     "searchKey": sprintf("google_composer_environment[%s].config", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_composer_environment[%s].region should not be attached with default service account", [name]),
     "keyActualValue": sprintf("google_composer_environment[%s].region is attached with default service account", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_composer_environment", name, "config"], []),
     "remediation": "create dedicated service account for app or workload and attach it",
     "remediationType": "update",
  }
}