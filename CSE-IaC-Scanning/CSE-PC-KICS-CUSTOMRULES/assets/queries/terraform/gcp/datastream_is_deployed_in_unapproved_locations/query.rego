package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   datastreamsrv := input.document[i].resource.google_datastream_stream[name]
   actualLocation := datastreamsrv.location
   expectedFromLocationlist := ["us-east4", "us-west2", "us-central1"]
   not common_lib.inArray(expectedFromLocationlist, actualLocation)

   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(datastreamsrv, name),
     "searchKey": sprintf("google_datastream_stream[%s].location", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].location should be defined and approved US locations", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].location is set as non approved location", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name, "location"], []),
     "remediation": "define and set only these US locations - us-east4, us-central1, us-west2",
     "remediationType": "update",
  }
}