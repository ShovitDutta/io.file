package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	clusterconfig := input.document[i].resource.google_dataproc_cluster[name].cluster_config[j]
	clusterconfig.endpoint_config[k].enable_http_port_access == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dataproc_cluster",
		"resourceName": tf_lib.get_resource_name(clusterconfig, name),
		"searchKey": sprintf("google_dataproc_cluster[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_dataproc_cluster[%s].cluster_config.endpoint_config.enable_http_port_access is false", [name]),
		"keyActualValue": sprintf("google_dataproc_cluster[%s].cluster_config.endpoint_config.enable_http_port_access is true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_dataproc_cluster", name], []),
		"remediation": "set enable_http_port_access = false",
		"remediationType": "update"
	}
}