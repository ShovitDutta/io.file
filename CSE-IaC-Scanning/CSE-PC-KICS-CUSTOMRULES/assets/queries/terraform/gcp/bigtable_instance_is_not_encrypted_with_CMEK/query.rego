package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	bigtableInstance := input.document[i].resource.google_bigtable_instance[name].cluster[j]
	object.get(bigtableInstance, "kms_key_name", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_bigtable_instance",
		"resourceName": tf_lib.get_resource_name(bigtableInstance, name),
		"searchKey": sprintf("google_bigtable_instance[%s].cluster.kms_key_name", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_bigtable_instance[%s].cluster.kms_key_name should be defined", [name]),
		"keyActualValue": sprintf("google_bigtable_instance[%s].cluster.kms_key_name is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_bigtable_instance", name, "cluster"], []),
		"remediation": "define the kms key name under cluster configuration",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
  bigtableInstance := input.document[i].resource.google_bigtable_instance[name].cluster[k]
  not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",bigtableInstance.kms_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_bigtable_instance",
     "resourceName": tf_lib.get_resource_name(bigtableInstance, name),
     "searchKey": sprintf("google_bigtable_instance[%s].cluster.kms_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_bigtable_instance[%s].cluster should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_bigtable_instance[%s].cluster is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_bigtable_instance", name, "cluster"], []),
     "remediation": "Attach a valid CMEK under cluster",
     "remediationType": "update",
  }
}