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
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings should be defined and set ALLOW_INTERNAL_ONLY ", [name]),
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config"], []),
     "remediation": "define and set ingress_settings as ALLOW_INTERNAL_ONLY",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].service_config[j]
   common_lib.emptyOrNull(cloudfunctionsrv.vpc_connector_egress_settings)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_cloudfunctions2_function",
     "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
     "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings should be defined and set ALL_TRAFFIC ", [name]),
     "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config", "vpc_connector_egress_settings"], []),
     "remediation": "define and set ingress_settings as ALL_TRAFFIC",
     "remediationType": "addition",
  }
}


CxPolicy[result] {
   cloudfunctionsrv := input.document[i].resource.google_cloudfunctions2_function[name].service_config[j]
   upper(cloudfunctionsrv.vpc_connector_egress_settings) != "ALL_TRAFFIC"
   result := {
      "documentId": input.document[i].id,
      "resourceType": "google_cloudfunctions2_function",
      "resourceName": tf_lib.get_resource_name(cloudfunctionsrv, name),
      "searchKey": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings", [name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings should be defined and set ALL_TRAFFIC ", [name]),
      "keyActualValue": sprintf("google_cloudfunctions2_function[%s].service_config.vpc_connector_egress_settings is undefined or not set ALL_TRAFFIC", [name]),
      "searchLine": common_lib.build_search_line(["resource", "google_cloudfunctions2_function", name, "service_config", "vpc_connector_egress_settings"], []),
      "remediation": "set vpc_connector_egress_settings as ALL_TRAFFIC",
      "remediationType": "replacement",
   }
}