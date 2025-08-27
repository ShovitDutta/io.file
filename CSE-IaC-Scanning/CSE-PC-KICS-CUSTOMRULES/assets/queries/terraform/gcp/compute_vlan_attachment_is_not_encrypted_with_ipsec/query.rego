package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_interconnect_attachment[name]
   not common_lib.valid_key(computeinterconnectsrv, "encryption")
   result := {
     "documentId": input.document[i].id,
     "resourceType": "google_compute_interconnect_attachment",
     "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
     "searchKey": sprintf("google_compute_interconnect_attachment[%s].encryption", [name]),
     "issueType": "MissingAttribute",
     "keyExpectedValue": sprintf("google_compute_interconnect_attachment[%s].encryption should be defined and set IPSEC", [name]),
     "keyActualValue": sprintf("google_compute_interconnect_attachment[%s].encryption is undefined", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_compute_interconnect_attachment", name], []),
     "remediation": "define and set encryption as IPSEC",
     "remediationType": "addition",
  }
}


CxPolicy[result] {
   computeinterconnectsrv := input.document[i].resource.google_compute_interconnect_attachment[name]
   computeinterconnectsrv.encryption != "IPSEC"
   result := {
      "documentId": input.document[i].id,
      "resourceType": "google_compute_interconnect_attachment",
      "resourceName": tf_lib.get_resource_name(computeinterconnectsrv, name),
      "searchKey": sprintf("google_compute_interconnect_attachment[%s].encryption", [name]),
      "issueType": "IncorrectValue",
      "keyExpectedValue": sprintf("google_compute_interconnect_attachment[%s].encryption should be defined and set as IPSEC", [name]),
      "keyActualValue": sprintf("google_compute_interconnect_attachment[%s].encryption is undefined or not set ALL_TRAFFIC", [name]),
      "searchLine": common_lib.build_search_line(["resource", "google_compute_interconnect_attachment", name, "encryption"], []),
      "remediation": "Update encryption as IPSEC",
     "remediationType": "update",
   }
}