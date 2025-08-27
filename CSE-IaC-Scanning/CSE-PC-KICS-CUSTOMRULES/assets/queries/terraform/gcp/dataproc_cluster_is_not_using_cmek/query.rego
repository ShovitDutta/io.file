package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dataProcCluster := input.document[i].resource.google_dataproc_cluster[name].cluster_config[k]
	encryptionConfig := dataProcCluster.encryption_config[m]
    count(encryptionConfig) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(dataProcCluster, name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": "google_dataproc_cluster[%s].cluster_config.encryption_config.kms_key_name should be defined",
		"keyActualValue": "google_dataproc_cluster[%s].cluster_config.encryption_config.kms_key_name is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "set kms_key_name under cluster_config.encryption_config",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
  	dataProcCluster := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	encryptionConfig := dataProcCluster.encryption_config[k]
  	not regex.match("^projects/(cvs-key-vault-prod|cvs-key-vault-nonprod)/locations/[a-zA-Z0-9-]+/keyRings/[a-zA-Z0-9-]+/cryptoKeys/gk-(?:[a-zA-Z0-9]+-)*[a-zA-Z0-9]+$",encryptionConfig.kms_key_name)
   
  result := {
     "documentId": input.document[i].id,
     "resourceType": "google_dataproc_cluster",
     "resourceName": tf_lib.get_resource_name(input.document[i].resource.google_dataproc_cluster[name], name),
     "searchKey": sprintf("google_dataproc_cluster[%s].cluster_config.cluster.kms_key_name", [name]),
     "issueType": "IncorrectValue",
     "keyExpectedValue": sprintf("google_dataproc_cluster[%s].cluster_config.encryption_config.kms_key_name should be attached valid CMEK", [name]),
     "keyActualValue": sprintf("google_dataproc_cluster[%s].cluster_config.encryption_config.kms_key_name is not attached CMEK", [name]),
     "searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name, "cluster"], []),
     "remediation": "Attach a valid CMEK under cluster",
     "remediationType": "update",
  }
}