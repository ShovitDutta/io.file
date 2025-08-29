package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
  	datastreamsrv := input.document[i].resource.google_datastream_stream[name]
  	not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",datastreamsrv.customer_managed_encryption_key)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_datastream_stream",
     "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_datastream_stream[name], name),
     "searchKey": sprintf("google_datastream_stream[%s].customer_managed_encryption_key", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_datastream_stream[%s].customer_managed_encryption_key should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_datastream_stream[%s].customer_managed_encryption_key is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_datastream_stream", name, "customer_managed_encryption_key"], []),
     "remediation": "Attach a valid CMEK under cluster",
     "remediationType": "update",
  }
}