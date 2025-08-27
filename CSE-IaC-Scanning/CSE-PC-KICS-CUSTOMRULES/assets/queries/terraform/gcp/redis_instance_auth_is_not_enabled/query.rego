package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  redisinstancesrv := input.document[i].resource.google_redis_instance[name]
  redisinstancesrv.auth_enabled == false
   
  result := {
    "documentId": input.document[i].id,
    "resourceType": "google_redis_instance",
    "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
    "searchKey": sprintf("google_redis_instance[%s].auth_enabled", [name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("google_redis_instance[%s].auth_enabled should be defined and set true", [name]),
    "keyActualValue": sprintf("google_redis_instance[%s].auth_enabled is undefined or not set as true", [name]),
    "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "auth_enabled"], []),
    "remediation": json.marshal({
      "before": false,
      "after": true
		}),
		"remediationType": "replacement",
  }
}

