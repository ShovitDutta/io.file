package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dataProcCluster := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	gceCluster := dataProcCluster.gce_cluster_config[k]
	not common_lib.valid_key(gceCluster, "internal_ip_only")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_dataproc_cluster[name], name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "MissingValue",
		"keyExpectedValue": "google_dataproc_cluster[%s].cluster_config.gce_cluster_config.internal_ip_only should be defined",
		"keyActualValue": "google_dataproc_cluster[%s].cluster_config.gce_cluster_config.internal_ip_only is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "set internal_ip_only under cluster_config.gce_cluster_config",
		"remediationType": "addition"
	}
}

CxPolicy[result] {
	clusterconfig := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	clusterconfig.gce_cluster_config[k].internal_ip_only == false
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_dataproc_cluster[name], name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("PTest google_dataproc_cluster[%s].cluster_config.gce_cluster_config.internal_ip_only should be set it true", [name]),
		"keyActualValue": sprintf("PTest google_dataproc_cluster[%s].cluster_config.gce_cluster_config.internal_ip_only is set it as false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "set internal_ip_only to true",
		"remediationType": "update"
	}
}