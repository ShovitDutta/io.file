package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].service_config[k]
   not common_lib.valid_key(cloudfunctionsrv, "vpc_connector")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_cloudfunctions2_function",
     "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
     "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector should be defined", [name]),
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config", "vpc_connector"], []),
     "remediation": "define vpc_connector under service_config",
     "remediationType": "addition",
  }
}


CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].service_config[k]
   cloudfunctionsrv.vpc_connector_egress_settings != "ALL_TRAFFIC"
   result := {
      "documentId": input.document[i].id,
      "resourceType": "google_cloudfunctions2_function",
      "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
      "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings", [name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings should be defined and set ALL_TRAFFIC ", [name]),
      "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings is undefined or not set ALL_TRAFFIC", [name]),
      "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config"], []),
      "remediation": "set vpc_connector_egress_settings as ALL_TRAFFIC",
      "remediationType": "replacement",
   }
}