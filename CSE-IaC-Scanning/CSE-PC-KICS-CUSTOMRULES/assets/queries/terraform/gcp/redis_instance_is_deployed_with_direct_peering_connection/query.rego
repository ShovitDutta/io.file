package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  redisinstancesrv := input.document[i].resource.google_redis_instance[name]
  not contains(upper(redisinstancesrv.connect_mode), "PRIVATE_SERVICE_ACCESS")
  
  result := {
    "documentId": input.document[i].id,
    "resourceType": "google_redis_instance",
    "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
    "searchKey": sprintf("google_redis_instance[%s].connect_mode", [name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("google_redis_instance[%s].connect_mode should be defined and set PRIVATE_SERVICE_ACCESS", [name]),
    "keyActualValue": sprintf("google_redis_instance[%s].connect_mode is undefined or not set as PRIVATE_SERVICE_ACCESS", [name]),
    "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "connect_mode"], []),
    "remediation": "define the connect_mode and set PRIVATE_SERVICE_ACCESS",
    "remediationType": "update",
  }
}

