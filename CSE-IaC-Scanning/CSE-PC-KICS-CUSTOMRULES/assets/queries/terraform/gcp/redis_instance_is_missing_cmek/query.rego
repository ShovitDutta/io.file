package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   redisinstancesrv := input.document[i].resource.google_redis_instance[name]
   not common_lib.valid_key(redisinstancesrv, "customer_managed_key")
   
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_redis_instance",
     "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
     "searchKey": sprintf("google_redis_instance[%s].customer_managed_key", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_redis_instance[%s].customer_managed_key should be defined", [name]),
     "keyActualValue": sprintf("google_redis_instance[%s].customer_managed_key is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "customer_managed_key"], []),
     "remediation": "define the customer_managed_key",
     "remediationType": "addition",
  }
}