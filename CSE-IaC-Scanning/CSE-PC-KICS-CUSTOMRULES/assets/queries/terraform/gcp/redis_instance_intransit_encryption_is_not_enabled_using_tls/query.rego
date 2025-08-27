package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  redisinstancesrv := input.document[i].resource.google_redis_instance[name]
  not contains(upper(redisinstancesrv.transit_encryption_mode), "SERVER_AUTHENTICATION")

  result := {
    "documentId": input.document[i].id,
    "resourceType": "google_redis_instance",
    "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
    "searchKey": sprintf("google_redis_instance[%s].transit_encryption_mode", [name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("google_redis_instance[%s].transit_encryption_mode should be defined and set SERVER_AUTHENTICATION", [name]),
    "keyActualValue": sprintf("google_redis_instance[%s].transit_encryption_mode is undefined or not set as SERVER_AUTHENTICATION", [name]),
    "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "transit_encryption_mode"], []),
    "remediation": "define the transit_encryption_mode and set SERVER_AUTHENTICATION",
    "remediationType": "update",
  }
}

