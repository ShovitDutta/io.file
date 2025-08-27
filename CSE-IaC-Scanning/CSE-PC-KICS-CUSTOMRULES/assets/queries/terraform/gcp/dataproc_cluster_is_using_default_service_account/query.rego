package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dataProcCluster := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	gceCluster := dataProcCluster.gce_cluster_config[k]
	not common_lib.valid_key(gceCluster, "service_account")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(dataProcCluster, name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_dataproc_cluster[%s].cluster_config.gce_cluster_config.service_account should be defined", [name]),
		"keyActualValue": sprintf("google_dataproc_cluster[%s].cluster_config.gce_cluster_config.service_account is undefined ", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "specify service account details under cluster_config.gce_cluster_config.service_account",
		"remediationType": "addition"
	}
}

CxPolicy[result] {	
	clusterconfig := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	contains(clusterconfig.gce_cluster_config[k].service_account, "compute@developer.gserviceaccount.com")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(clusterconfig, name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_dataproc_cluster[%s].cluster_config.gce_cluster_config.service_account should not have default SA ", [name]),
		"keyActualValue": sprintf("google_dataproc_cluster[%s].cluster_config.gce_cluster_config.service_account has default service account", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "remove the default service account and add the custom service account that has least privilege",
		"remediationType": "update"
	}
}