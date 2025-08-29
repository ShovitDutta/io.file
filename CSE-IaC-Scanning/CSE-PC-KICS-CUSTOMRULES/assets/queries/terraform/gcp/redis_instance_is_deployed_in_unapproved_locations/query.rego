package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   redisinstancesrv := input.document[i].resource.google_redis_instance[name]
   not common_lib.valid_key(redisinstancesrv, "location_id")
   
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_redis_instance",
     "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
     "searchKey": sprintf("google_redis_instance[%s].location_id", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_redis_instance[%s].location_id should be defined and set US locations", [name]),
     "keyActualValue": sprintf("google_redis_instance[%s].location_id is undefined or set as non approved location", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name], []),
     "remediation": "define the location_id and set only US location us-east4 us-west2 us-central1",
     "remediationType": "addition",
  }
}

CxPolicy[result] {
   redisinstancesrv := input.document[i].resource.google_redis_instance[name]
   actualLocation := redisinstancesrv.location_id
   expectedFromLocationlist := ["us-east4", "us-west2", "us-central1"]
   not common_lib.inArray(expectedFromLocationlist, actualLocation)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_redis_instance",
     "resourceName": tf_lib.get_resource_name(redisinstancesrv, name),
     "searchKey": sprintf("google_redis_instance[%s].location_id", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_redis_instance[%s].location_id should be defined and set US locations", [name]),
     "keyActualValue": sprintf("google_redis_instance[%s].location_id is set as non approved location", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_redis_instance", name, "location_id"], []),
     "remediation": "define and set only US location us-east4, us-west2, us-central1",
     "remediationType": "update",
  }
}